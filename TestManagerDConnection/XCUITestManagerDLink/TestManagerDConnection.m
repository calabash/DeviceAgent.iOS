#include <CoreFoundation/CoreFoundation.h>
#import "DTXRemoteInvocationReceipt.h"
#import "TestManagerDConnection.h"
#import "DTXSocketTransport.h"
#import "DTXConnection.h"
#import "DTXProxyChannel.h"
#import <objc/runtime.h>
#include <stdio.h>

// gcc tmd_connect.c -o tmd_connect -framework CoreFoundation -F. -framework MobileDevice

#ifdef DEBUG
#define Dprintf fprintf
#else
#define Dprintf(...)
#endif

// These are obviously internal to Apple. The void * is likely some AMDDeviceRef * or something like that
// But since it's opaque anyway, just void * it..

@class AMDServiceConnection;

extern int AMDeviceConnect (void *device);
extern int AMDeviceValidatePairing (void *device);
extern int AMDeviceStartSession (void *device);
extern int AMDeviceStopSession (void *device);
extern int AMDeviceDisconnect (void *device);
extern int AMDServiceConnectionGetSocket(AMDServiceConnection *something);

extern int AMDServiceConnectionReceive(void *device, unsigned char *buf,int size, int );

extern int AMDeviceSecureStartService(void *device,
                                      CFStringRef serviceName, // One of the services in lockdown's Services.plist
                                      CFDictionaryRef opts,
                                      void *handle);

extern int AMDeviceNotificationSubscribe(void *, int , int , int, void **);

struct AMDeviceNotificationCallbackInformation {
    void 		*deviceHandle;
    uint32_t	msgType;
} ;

@implementation TestManagerDConnection

void validatePairing(void *deviceHandle) {
    printf("Validate pairing...\n");
    int rc = AMDeviceValidatePairing(deviceHandle);
    if (rc) {
        fprintf (stderr, "AMDeviceValidatePairing() returned: %d\n", rc);
        exit(2);
    }
}

void startSession(void *deviceHandle) {
    printf("Starting session...\n");
    int rc = AMDeviceStartSession(deviceHandle);
    if (rc) {
        fprintf (stderr, "AMStartSession() returned: %d\n", rc);
        exit(2);
    }
}

AMDServiceConnection *secureStartService(void *deviceHandle, CFStringRef serviceName, CFDictionaryRef opts) {
    printf("Connecting to %s...\n", CFStringGetCStringPtr(serviceName, kCFStringEncodingUTF8));
    AMDServiceConnection *handle;
    int rc = AMDeviceSecureStartService(deviceHandle, serviceName, opts, &handle);
    
    if (rc) {
        fprintf(stderr, "Unable to start service -- Rc %d fd: %p\n", rc, handle);
        exit(4);
    }
    return handle;
}

void stopSession(void *deviceHandle) {
    printf("Stopping session...\n");
    int rc = AMDeviceStopSession(deviceHandle);
    if (rc) {
        fprintf(stderr, "Unable to disconnect - rc is %d\n",rc);
        exit(4);
    }
}

void disconnect(void *deviceHandle) {
    printf("Disconnecting...\n");
    int rc = AMDeviceDisconnect(deviceHandle);
    
    if (rc != 0) {
        fprintf(stderr, "Unable to disconnect - rc is %d\n",rc);
        exit(5);
    }
}

void printPListType(CFPropertyListFormat format) {
    switch (format) {
        case kCFPropertyListOpenStepFormat:
            printf("Format is OpenStepFormat\n");
            break;
        case kCFPropertyListXMLFormat_v1_0:
            printf("Format is XMLFormat\n");
            break;
        case kCFPropertyListBinaryFormat_v1_0:
            printf("Format is Binary\n");
            break;
    }
}

CFMutableDictionaryRef getConnectionOpts() {
    int NUM_OBJS = 2;
    CFMutableDictionaryRef dict = CFDictionaryCreateMutable(
                                                            NULL,
                                                            NUM_OBJS,
                                                            &kCFTypeDictionaryKeyCallBacks,
                                                            &kCFTypeDictionaryValueCallBacks);
    
    if (!dict) {
        printf("Dict is null\n");
    }
    
//    CFDictionarySetValue(dict, "CloseOnInvalidate", kCFBooleanTrue);
//    CFDictionarySetValue(dict, "InvalidateOnDetach", kCFBooleanTrue);
    
    return dict;
}

void deviceConnect(void *deviceHandle) {
    int rc = AMDeviceConnect(deviceHandle);
    
    if (rc) {
        fprintf (stderr, "AMDeviceConnect returned: %d\n", rc);
        exit(1);
    }
}

void setup(void *deviceHandle) {
    deviceConnect(deviceHandle);
    validatePairing(deviceHandle);
    startSession(deviceHandle);
}

void cleanup(void *deviceHandle) {
    stopSession(deviceHandle);
    disconnect(deviceHandle);
}

void connectToTestManagerD(void *deviceHandle) {
    setup(deviceHandle);
    
    AMDServiceConnection *serviceConnection = secureStartService(deviceHandle,
                           CFSTR("com.apple.testmanagerd.lockdown"),
                           getConnectionOpts());
    
    if (serviceConnection) {
        printf("Got AMDServiceConnection!\n");
    }
    
    int socket = AMDServiceConnectionGetSocket(serviceConnection);
    DTXSocketTransport *socketTransport = [[DTXSocketTransport alloc] initWithConnectedSocket:socket
                                                                             disconnectAction:nil];
    DTXConnection *connection = [[DTXConnection alloc] initWithTransport:socketTransport];

    
    Protocol *daemonProtocol = @protocol(XCTestManager_DaemonConnectionInterface);
    Protocol *managerProtocol = @protocol(XCTestManager_IDEInterface);
    
    DTXProxyChannel *channel = [connection makeProxyChannelWithRemoteInterface:daemonProtocol
                                                             exportedInterface:managerProtocol];
    
    [connection resume];
    id<XCTestManager_DaemonConnectionInterface> proxy = [channel remoteObjectProxy];
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"BEEFBABE-FEED-BABE-BEEF-CAFEBEEFFACE"];
    //vu+6vv7tur6+78r+vu/6zg==
    
    NSString *client = @"0706320C-D7F3-4329-B9D7-90DC60ED0D60-1649-000002BA5B14AC2F";
    NSString *path = @"/Applications/Xcode.app";
    
    [proxy _IDE_initiateSessionWithIdentifier:uuid
                                    forClient:client
                                       atPath:path
                              protocolVersion:@(16)];
    
    
    NSString *pid = [[NSString alloc] initWithContentsOfFile:@"/Users/chrisf/Desktop/runnerpid.txt" encoding:NSUTF8StringEncoding error:nil];
    [connection handleProxyRequestForInterface:@protocol(XCTestManager_IDEInterface)
                                 peerInterface:@protocol(XCTestDriverInterface)
                                       handler:^(DTXProxyChannel *channel){ /* ??? */
                                           NSLog(@"handleProxyRequestForInterface");
                                           id <XCTestDriverInterface> testBundleProxy = [channel remoteObjectProxy];
                                          
                                           [proxy _IDE_initiateControlSessionForTestProcessID:@([pid integerValue])];
                                           [testBundleProxy _IDE_startExecutingTestPlanWithProtocolVersion:@(16)];
                                           [proxy _IDE_beginSessionWithIdentifier:uuid forClient:client atPath:path];
                                       }];
    
    CFRunLoopRun();
    
//    cleanup(deviceHandle);
}

void callback(struct AMDeviceNotificationCallbackInformation *CallbackInfo) {
    
    void *deviceHandle = CallbackInfo->deviceHandle;
    
    switch (CallbackInfo->msgType) {
        case 1:
            fprintf(stderr, "Device %p connected\n", deviceHandle);
            connectToTestManagerD(deviceHandle);
            break;
        case 2:
            fprintf(stderr, "Device %p disconnected\n", deviceHandle);
            break;
        case 3:
            fprintf(stderr, "Unsubscribed\n");
            break;
            
        default:
            fprintf(stderr, "Unknown message %d\n", CallbackInfo->msgType);
    }
}

+ (void)connect {
    void *subscribe;
    
    int rc = AMDeviceNotificationSubscribe(callback, 0,0,0, &subscribe);
    if (rc <0) {
        fprintf(stderr, "Unable to subscribe: AMDeviceNotificationSubscribe returned %d\n", rc);
        exit(1);
    }
    CFRunLoopRun();
}

@end


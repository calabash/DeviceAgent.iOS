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


@interface TestManagerDConnection ()
@property (nonatomic, strong) id <XCTestDriverInterface> testBundleProxy;
@property DTXConnection *connection;
@property (nonatomic, strong) NSUUID *sessionId;
@end

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

- (id)_XCT_nativeFocusItemDidChangeAtTime:(NSNumber *)arg1 parameterSnapshot:(XCElementSnapshot *)arg2 applicationSnapshot:(XCElementSnapshot *)arg3 {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}

- (id)_XCT_recordedEventNames:(NSArray *)arg1 timestamp:(NSNumber *)arg2 duration:(NSNumber *)arg3 startLocation:(NSDictionary *)arg4 startElementSnapshot:(XCElementSnapshot *)arg5 startApplicationSnapshot:(XCElementSnapshot *)arg6 endLocation:(NSDictionary *)arg7 endElementSnapshot:(XCElementSnapshot *)arg8 endApplicationSnapshot:(XCElementSnapshot *)arg9 {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_testCase:(NSString *)arg1 method:(NSString *)arg2 didFinishActivity:(XCActivityRecord *)arg3{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_testCase:(NSString *)arg1 method:(NSString *)arg2 willStartActivity:(XCActivityRecord *)arg3{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_recordedOrientationChange:(NSString *)arg1{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_recordedFirstResponderChangedWithApplicationSnapshot:(XCElementSnapshot *)arg1{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_exchangeCurrentProtocolVersion:(NSNumber *)arg1 minimumVersion:(NSNumber *)arg2{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_recordedKeyEventsWithApplicationSnapshot:(XCElementSnapshot *)arg1 characters:(NSString *)arg2 charactersIgnoringModifiers:(NSString *)arg3 modifierFlags:(NSNumber *)arg4{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_recordedEventNames:(NSArray *)arg1 duration:(NSNumber *)arg2 startLocation:(NSDictionary *)arg3 startElementSnapshot:(XCElementSnapshot *)arg4 startApplicationSnapshot:(XCElementSnapshot *)arg5 endLocation:(NSDictionary *)arg6 endElementSnapshot:(XCElementSnapshot *)arg7 endApplicationSnapshot:(XCElementSnapshot *)arg8;
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_recordedKeyEventsWithCharacters:(NSString *)arg1 charactersIgnoringModifiers:(NSString *)arg2 modifierFlags:(NSNumber *)arg3{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_recordedEventNames:(NSArray *)arg1 duration:(NSNumber *)arg2 startElement:(XCAccessibilityElement *)arg3 startApplicationSnapshot:(XCElementSnapshot *)arg4 endElement:(XCAccessibilityElement *)arg5 endApplicationSnapshot:(XCElementSnapshot *)arg6{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_recordedEvent:(NSString *)arg1 targetElementID:(NSDictionary *)arg2 applicationSnapshot:(XCElementSnapshot *)arg3{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_recordedEvent:(NSString *)arg1 forElement:(NSString *)arg2{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_logDebugMessage:(NSString *)arg1{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_logMessage:(NSString *)arg1{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_testMethod:(NSString *)arg1 ofClass:(NSString *)arg2 didMeasureMetric:(NSDictionary *)arg3 file:(NSString *)arg4 line:(NSNumber *)arg5{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_testCase:(NSString *)arg1 method:(NSString *)arg2 didStallOnMainThreadInFile:(NSString *)arg3 line:(NSNumber *)arg4{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_testCaseDidFinishForTestClass:(NSString *)arg1 method:(NSString *)arg2 withStatus:(NSString *)arg3 duration:(NSNumber *)arg4{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_testCaseDidFailForTestClass:(NSString *)arg1 method:(NSString *)arg2 withMessage:(NSString *)arg3 file:(NSString *)arg4 line:(NSNumber *)arg5{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_testCaseDidStartForTestClass:(NSString *)arg1 method:(NSString *)arg2{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_testSuite:(NSString *)arg1 didFinishAt:(NSString *)arg2 runCount:(NSNumber *)arg3 withFailures:(NSNumber *)arg4 unexpected:(NSNumber *)arg5 testDuration:(NSNumber *)arg6 totalDuration:(NSNumber *)arg7{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_testSuite:(NSString *)arg1 didStartAt:(NSString *)arg2{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_didFinishExecutingTestPlan{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_didBeginExecutingTestPlan{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_testBundleReadyWithProtocolVersion:(NSNumber *)arg1 minimumVersion:(NSNumber *)arg2{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_getProgressForLaunch:(id)arg1{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_terminateProcess:(id)arg1{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_launchProcessWithPath:(NSString *)arg1 bundleID:(NSString *)arg2 arguments:(NSArray *)arg3 environmentVariables:(NSDictionary *)arg4{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}

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

+ (DTXSocketTransport *)getTransport:(void *)deviceHandle {
    AMDServiceConnection *serviceConnection = secureStartService(deviceHandle,
                                                                 CFSTR("com.apple.testmanagerd.lockdown"),
                                                                 getConnectionOpts());
    
    if (serviceConnection) {
        printf("Got AMDServiceConnection!\n");
    }
    
    int socket = AMDServiceConnectionGetSocket(serviceConnection);
    DTXSocketTransport *socketTransport = [[DTXSocketTransport alloc] initWithConnectedSocket:socket
                                                                             disconnectAction:nil];
    return socketTransport;
}

- (void)setupTestBundleConnectionWithTransport:(DTXSocketTransport *)transport {
    NSLog(@"TMDLink: Creating the connection");
    DTXConnection *connection = [[DTXConnection alloc] initWithTransport:transport];

    [connection registerDisconnectHandler:^{
        NSLog(@"Disconnected handler...");
    }];
    
    NSLog(@"TMDLink: Listening for proxy connection request from the test bundle (all platforms)");

    [connection handleProxyRequestForInterface:@protocol(XCTestManager_IDEInterface)
                                 peerInterface:@protocol(XCTestDriverInterface)
                                       handler:^(DTXProxyChannel *conn){
                                                
                                                NSLog(@"HandleProxyRequestForInterface: XCTestManager_IDEInterface, XCTestDriverInterface");
                                                [conn setExportedObject:self queue:dispatch_get_main_queue()];
                                                self.testBundleProxy = [conn remoteObjectProxy];
                                            }];
    NSLog(@"TMDLink: Resuming the connection.");
    [connection resume];
}

- (void)connectToTestManagerD:(void *)deviceHandle {
//
//    DTXSocketTransport *socketTransport = [TestManagerDConnection getTransport:deviceHandle];
//    DTXConnection *connection = [[DTXConnection alloc] initWithTransport:socketTransport];
//
//    //vu+6vv7tur6+78r+vu/6zg==
//    
//    NSString *client = @"0706320C-D7F3-4329-B9D7-90DC60ED0D60-1649-000002BA5B14AC2F";
//    NSString *path = @"/Applications/Xcode.app";
//    
//    [connection handleProxyRequestForInterface:@protocol(XCTestManager_IDEInterface)
//                                 peerInterface:@protocol(XCTestDriverInterface)
//                                       handler:^(DTXProxyChannel *chan){ /* ??? */
//                                           
//                                           
//                                       }];
//    [connection resume];
//    
//    Protocol *daemonProtocol = @protocol(XCTestManager_DaemonConnectionInterface);
//    Protocol *managerProtocol = @protocol(XCTestManager_IDEInterface);
//    
//    DTXProxyChannel *channel = [connection makeProxyChannelWithRemoteInterface:daemonProtocol
//                                                             exportedInterface:managerProtocol];
//    
//    id<XCTestManager_DaemonConnectionInterface> proxy = [channel remoteObjectProxy];
//    
//    [proxy _IDE_initiateSessionWithIdentifier:uuid
//                                    forClient:client
//                                       atPath:path
//                              protocolVersion:@(14)];
//    
//    NSString *pid = [[NSString alloc] initWithContentsOfFile:@"/Users/chrisf/Desktop/runnerpid.txt" encoding:NSUTF8StringEncoding error:nil];
////    [testBundleProxy _IDE_startExecutingTestPlanWithProtocolVersion:@(16)];
//    [proxy _IDE_initiateControlSessionForTestProcessID:@([pid integerValue])];
//    [proxy _IDE_beginSessionWithIdentifier:uuid forClient:client atPath:path];
//    
//    
//    CFRunLoopRun();
//    
}

- (void)handleDaemonConnection:(DTXConnection *)connection {
    NSLog(@"TDMLink: Checking test manager availability...");
    DTXProxyChannel *channel = [connection makeProxyChannelWithRemoteInterface:@protocol(XCTestManager_DaemonConnectionInterface)
                                                             exportedInterface:@protocol(XCTestManager_IDEInterface)];
        [channel setExportedObject:self queue:dispatch_get_main_queue()];
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *pathExtension = [bundlePath pathExtension];
    if ([pathExtension isEqualToString:@"app"]) {
        bundlePath = [[NSBundle mainBundle] executablePath];
    }
    static dispatch_once_t onceToken;
    static NSString *clientProcessUniqueIdentifier;
        dispatch_once(&onceToken, ^{
            clientProcessUniqueIdentifier = [[NSProcessInfo processInfo] globallyUniqueString];
        });
    id <XCTestManager_DaemonConnectionInterface> remoteObjectProxy = [channel remoteObjectProxy];
//        rax = [_objc_release operation]; ??
//        rax = [rax launchSession]; ??

    NSLog(@"Starting test session with ID %@", self.sessionId);
    __block DTXRemoteInvocationReceipt *receipt = [remoteObjectProxy _IDE_initiateSessionWithIdentifier:self.sessionId
                                                                                              forClient:clientProcessUniqueIdentifier
                                                                                                 atPath:bundlePath
                                                                                        protocolVersion:@(16)];
    
    [receipt handleCompletion:^{
        receipt = [remoteObjectProxy _IDE_beginSessionWithIdentifier:self.sessionId
                                                                forClient:clientProcessUniqueIdentifier
                                                                   atPath:bundlePath];
        
        [receipt handleCompletion:^{
            NSLog(@"TMDLink: testmanagerd handled session request.");
            dispatch_async(dispatch_get_main_queue(), ^{
                //Ready for test bundle to connect
                //Wait for launch
            });
        }];
        
    }];
}

void callback(struct AMDeviceNotificationCallbackInformation *CallbackInfo) {
    
    void *deviceHandle = CallbackInfo->deviceHandle;
    
    switch (CallbackInfo->msgType) {
        case 1: {
            fprintf(stderr, "Device %p connected\n", deviceHandle);
            setup(deviceHandle); //IDEiOSDeviceCore
            
            TestManagerDConnection *tmd = [TestManagerDConnection new];
            NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"BEEFBABE-FEED-BABE-BEEF-CAFEBEEFFACE"];
            tmd.sessionId = uuid;
            
            //LAUNCH APP
            //TODO
            
            //CONNECT TO TEST BUNDLE
            DTXSocketTransport *trans = [TestManagerDConnection getTransport:deviceHandle];
            [tmd setupTestBundleConnectionWithTransport:trans];
            
            //CONNECT TO TESTMANAGERD
            NSLog(@"TMDLINK: Test connection requires daemon assistance");
//            DTXSocketTransport *trans2 = [TestManagerDConnection getTransport:deviceHandle];
            [tmd handleDaemonConnection:tmd.connection];
            
//            cleanup(deviceHandle); ??
            break;
        }
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


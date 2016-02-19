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
@property (nonatomic, strong) id <XCTestManager_DaemonConnectionInterface> daemonProxy;
@property DTXConnection *connection;
@property DTXConnection *daemonConnection;
@property (nonatomic, strong) NSUUID *sessionId;
@property (nonatomic, strong) NSNumber *testProtocolVersion;
@property (nonatomic, strong) NSNumber *daemonProtocolVersion;
@property (nonatomic)   void *targetDevice;
@property (nonatomic) BOOL isValid;
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
- (id)_XCT_logDebugMessage:(NSString *)msg {
    NSLog(@"%@: %@", NSStringFromSelector(_cmd), msg);
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
    NSLog(@"%@ :: %@ : %@", NSStringFromSelector(_cmd), arg1, arg2);
    return nil;
}
- (id)_XCT_testSuite:(NSString *)arg1 didFinishAt:(NSString *)arg2 runCount:(NSNumber *)arg3 withFailures:(NSNumber *)arg4 unexpected:(NSNumber *)arg5 testDuration:(NSNumber *)arg6 totalDuration:(NSNumber *)arg7{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return nil;
}
- (id)_XCT_testSuite:(NSString *)arg1 didStartAt:(NSString *)arg2{
    NSLog(@"%@ :: %@ :: %@", NSStringFromSelector(_cmd), arg1, arg2);
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
- (id)_XCT_testBundleReadyWithProtocolVersion:(NSNumber *)protocolVersion minimumVersion:(NSNumber *)minimumVersion {
    /*
        TODO: Xcode starts a timoutTimer here
     */
    self.testProtocolVersion = protocolVersion;
    NSLog(@"TMDLink: Test bundle is ready, running protocol %@, requires at least version %@. IDE is running %@ and requires at least %@", protocolVersion, minimumVersion, protocolVersion /*?*/, minimumVersion /*?*/);
    if ([minimumVersion integerValue] < 0x11) {
        if ([[self testProtocolVersion] integerValue] > 0x7)  {
                /*
                    I don't see this used anywhere...
                 */
                void *device = [self targetDevice];
            
                BOOL requiresAssistance = [self requiresTestDaemonMediationForTestHostConnection];
                if (requiresAssistance != 0x0) {
                    [self _whitelistTestProcessIDForUITesting];
                }
                else {
                    /*
                     TODO: Simulature connection
                        r14 = [[r12 operation] retain];
                        rbx = [[r14 launchSession] retain];
                        rax = [rbx runnablePID];
                        [r12 _checkUITestingPermissionsForPID:rax];
                        [rbx release];
                        [r14 release];
                     */
                }
                return 0x0;
        }
    } else {
        NSString *err = [NSString stringWithFormat:@"Protocol mismatch: IDE requires at least version %@, test process is running version %@", minimumVersion, [self testProtocolVersion]];
        NSLog(@"TMDLink: %@", err);
    }
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

- (BOOL)requiresTestDaemonMediationForTestHostConnection {
    /*
        I think this is always YES for physical devices, NO for sims
     */
    return YES;
}

- (DTXSocketTransport *)makeTransportForTestManagerService:(NSError **)err {
    AMDServiceConnection *serviceConnection = secureStartService(self.targetDevice,
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

- (void)_whitelistTestProcessIDForUITesting {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT /* 0x0 */, 0x0), ^{
        TestManagerDConnection *rbx = self;
        if ([self isValid] != 0x0) {
            NSLog(@"TMDLink: Creating secondary transport and connection for whitelisting test process PID.");
            void *r2 = self.targetDevice;
            
            NSError *err = 0x0;
            DTXSocketTransport *r15 = [self makeTransportForTestManagerService:&err];
            if ([self isValid] != 0x0) {
                if (err != 0x0) {
                    NSLog(@"Failure to create transport for test daemon:\n%@", err);
                }
                if (r15 != 0x0) {
                    DTXConnection *conn = [[DTXConnection alloc] initWithTransport:r15];
                    [self setDaemonConnection:conn];
                    [self.daemonConnection registerDisconnectHandler:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TMDLink: Lost connection to test manager service.");
                        });
                        
                        //TODO: only when we're totally done.
                        cleanup(self.targetDevice);

                    }];
                    
                    NSLog(@"TMDLink: Resuming the secondary connection.");
                    [self.daemonConnection resume];

                    Protocol *r = @protocol(XCTestManager_DaemonConnectionInterface);
                    Protocol *e = @protocol(XCTestManager_IDEInterface);
                    DTXProxyChannel *channel = [self.daemonConnection makeProxyChannelWithRemoteInterface:r
                                                                                        exportedInterface:e];

                    [channel setExportedObject:self queue:dispatch_get_main_queue()];
                    
                    id <XCTestManager_DaemonConnectionInterface> remoteProxy = [channel remoteObjectProxy];
                    self.daemonProxy = remoteProxy;

                    /*
                     Right here, we need to get the PID of the process somehows...
                    r12 = [(r13)(r15, @selector(operation)) retain];
                    rbx = [(r14)(r12, @selector(launchSession)) retain];
                     */
                    
                    //HACK
                    int pid = [[NSString stringWithContentsOfFile:@"/Users/chrisf/Desktop/runnerpid.txt"
                                                         encoding:NSUTF8StringEncoding
                                                            error:nil] intValue];
                    //END_HACK
                    
                    NSLog(@"Whitelisting test process ID %d", pid);
                    
                    DTXRemoteInvocationReceipt *receipt = [self.daemonProxy _IDE_initiateControlSessionForTestProcessID:@(pid)
                                                                                                        protocolVersion:self.testProtocolVersion];
                    
//                    DTXRemoteInvocationReceipt *r2 = [self.daemonProxy _IDE_initiateControlSessionForTestProcessID:@(pid)];
                    
//                    [r2 handleCompletion:^(NSNumber *n, NSError *err) {
//                        NSLog(@"Handle completion for '_IDE_initiateControlSessionForTestProcessID': %@, %@", n, err);
//                    }];
                    
                    [receipt handleCompletion:^(NSNumber *n, NSError *err) {
                        self.daemonProtocolVersion = n;
                        NSLog(@"TMDLink: Got whitelisting response and daemon protocol version %d", [n intValue]);
                        [self.testBundleProxy _IDE_startExecutingTestPlanWithProtocolVersion:@(0x10)];
                        
                        //TODO: there's another block invoke?
                    }];
                } else {
                    NSLog(@"Failed to create transport service for daemon connection");
                }
            }
        }
        return;
    });
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
    CFMutableDictionaryRef dict = CFDictionaryCreateMutable(NULL,
                                                            0,
                                                            &kCFTypeDictionaryKeyCallBacks,
                                                            &kCFTypeDictionaryValueCallBacks);
    
    CFDictionarySetValue(dict, CFSTR("CloseOnInvalidate"), kCFBooleanTrue);
    CFDictionarySetValue(dict, CFSTR("InvalidateOnDetach"), kCFBooleanTrue);
    
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

- (void)setupTestBundleConnectionWithTransport:(DTXSocketTransport *)transport {
    NSLog(@"TMDLink: Creating the connection");
    self.connection = [[DTXConnection alloc] initWithTransport:transport];
    
    [self.connection registerDisconnectHandler:^{
        NSLog(@"TMDLink: Disconnected handler...");
        //TODO: only when we're totally done.
        cleanup(self.targetDevice);
    }];
    
    NSLog(@"TMDLink: Listening for proxy connection request from the test bundle (all platforms)");
    [self.connection handleProxyRequestForInterface:@protocol(XCTestManager_IDEInterface)
                                      peerInterface:@protocol(XCTestDriverInterface)
                                            handler:^(DTXProxyChannel *conn){
                                                
                                                NSLog(@"HandleProxyRequestForInterface: XCTestManager_IDEInterface, XCTestDriverInterface");
                                                [conn setExportedObject:self queue:dispatch_get_main_queue()];
                                                self.testBundleProxy = [conn remoteObjectProxy];
                                            }];
    NSLog(@"TMDLink: Resuming the connection.");
    
    [self.connection resume];
}

- (void)handleDaemonConnection:(DTXConnection *)connection {
    NSLog(@"TDMLink: Checking test manager availability...");
    DTXProxyChannel *channel = [connection makeProxyChannelWithRemoteInterface:@protocol(XCTestManager_DaemonConnectionInterface)
                                                             exportedInterface:@protocol(XCTestManager_IDEInterface)];
    
    [channel setExportedObject:self
                         queue:dispatch_get_main_queue()];
    /*
        Xcode dynamically obtains bundlePath through [[NSBundle mainBundle] bundlePath]
     */
    NSString *bundlePath = @"/Applications/Xcode.app";
    static dispatch_once_t onceToken;
    static NSString *clientProcessUniqueIdentifier;
        dispatch_once(&onceToken, ^{
            clientProcessUniqueIdentifier = [[NSProcessInfo processInfo] globallyUniqueString];
        });
    id <XCTestManager_DaemonConnectionInterface> remoteObjectProxy = [channel remoteObjectProxy];
    
    /*
        At this point, Xcode reads the test configuration from the test run launch operation object
     */

    NSLog(@"TDMLink Starting test session with ID %@", self.sessionId);
    __block DTXRemoteInvocationReceipt *receipt = [remoteObjectProxy _IDE_initiateSessionWithIdentifier:self.sessionId
                                                                                              forClient:clientProcessUniqueIdentifier
                                                                                                 atPath:bundlePath
                                                                                        protocolVersion:@(0x10)];
    
    [receipt handleCompletion:^(NSNumber *n /* 14 ?? */, NSError *e){
        /**
         EXACTLY HERE, launch alex's app, then continue.
         */
        DTXRemoteInvocationReceipt *r2 = [remoteObjectProxy _IDE_beginSessionWithIdentifier:self.sessionId
       
                                                                                  forClient:clientProcessUniqueIdentifier
                                                                                     atPath:bundlePath];

        [r2 handleCompletion:^(NSNumber *n, NSError *e){
            if (e) {
                NSLog(@"Error beginning session with ID: %@ %@", self.sessionId, e);
            } else {
                NSLog(@"TMDLink: testmanagerd handled session request.");
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"TMDLink: ready for testBundleToConnect, wait for launch");
                });
            }
        }];
    }];
}

void callback(struct AMDeviceNotificationCallbackInformation *CallbackInfo) {
    
    void *deviceHandle = CallbackInfo->deviceHandle;
    static BOOL doIt = YES;
    if (doIt) {
        doIt = NO;
    switch (CallbackInfo->msgType) {
        case 1: {
            fprintf(stderr, "Device %p connected\n", deviceHandle);
            setup(deviceHandle); //IDEiOSDeviceCore
            
            TestManagerDConnection *tmd = [TestManagerDConnection new];
            tmd.isValid = YES;
            tmd.targetDevice = deviceHandle;
            NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"BEEFBABE-FEED-BABE-BEEF-CAFEBEEFFACE"];
            tmd.sessionId = uuid;
            
            //LAUNCH APP ??
            //TODO
            
            //CONNECT TO TEST BUNDLE
            DTXSocketTransport *trans = [tmd makeTransportForTestManagerService:nil];
            [tmd setupTestBundleConnectionWithTransport:trans];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                //CONNECT TO TESTMANAGERD
                NSLog(@"TMDLink: Test connection requires daemon assistance");
                [tmd handleDaemonConnection:tmd.connection];
            });
            
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


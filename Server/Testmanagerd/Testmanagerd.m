
#import "Testmanagerd.h"
#import "XCTRunnerDaemonSession.h"
#import <objc/runtime.h>
#import "CBXException.h"

#ifndef __IPHONE_11_0
#import "NSXPCConnection.h"
#endif

@interface Testmanagerd_EventSynthesis()
@end

@implementation Testmanagerd_EventSynthesis

+ (id<XCTMessagingChannel_RunnerToDaemon>)get {

    static id <XCTMessagingChannel_RunnerToDaemon> managerInterface = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class xctRunnerDaemonSessionClass = objc_lookUpClass("XCTRunnerDaemonSession");
        if (xctRunnerDaemonSessionClass) {
            // Xcode >= 8.3
            XCTRunnerDaemonSession *session = [xctRunnerDaemonSessionClass sharedSession];
            managerInterface = [session daemonProxy];
        } else {
            @throw [CBXException withMessage:@"Could not obtain a reference to XCTestManager."];
        }
    });
    return managerInterface;
}

@end


@interface Testmanagerd_CapabilityExchange()
@end

@implementation Testmanagerd_CapabilityExchange

+ (id<XCTMessagingChannel_RunnerToDaemon>)get {

    static id <XCTMessagingChannel_RunnerToDaemon> managerInterface = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class xctRunnerDaemonSessionClass = objc_lookUpClass("XCTRunnerDaemonSession");
        if (xctRunnerDaemonSessionClass) {
            // Xcode >= 8.3
            XCTRunnerDaemonSession *session = [xctRunnerDaemonSessionClass sharedSession];
            managerInterface = [session daemonProxy];
        } else {
            @throw [CBXException withMessage:@"Could not obtain a reference to XCTestManager."];
        }
    });
    return managerInterface;
}

@end

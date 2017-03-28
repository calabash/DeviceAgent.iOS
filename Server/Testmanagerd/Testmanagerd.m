
#import "Testmanagerd.h"
#import "XCTestDriver.h"
#import "NSXPCConnection.h"
#import "XCTRunnerDaemonSession.h"
#import <objc/runtime.h>
#import "CBXException.h"


@interface Testmanagerd()
@end

@implementation Testmanagerd

+ (id<XCTestManager_ManagerInterface>)get {

    static id <XCTestManager_ManagerInterface> managerInterface = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class xctRunnerDaemonSessionClass = objc_lookUpClass("XCTRunnerDaemonSession");
        if (xctRunnerDaemonSessionClass) {
            // Xcode >= 8.3
            XCTRunnerDaemonSession *session = [xctRunnerDaemonSessionClass sharedSession];
            managerInterface = [session daemonProxy];
        } else if ([[XCTestDriver sharedTestDriver] respondsToSelector:@selector(managerProxy)]) {
            // Xcode < 8.3
            managerInterface = [[XCTestDriver sharedTestDriver] managerProxy];
        } else {
            @throw [CBXException withMessage:@"Could not obtain a reference to XCTestManager."];
        }
    });
    return managerInterface;
}

@end


#import "Application.h"
#import "CBX-XCTest-Umbrella.h"
#import "XCTest+CBXAdditions.h"
#import "XCElementSnapshot.h"
#import "XCElementSnapshot-Hitpoint.h"
#import "Testmanagerd.h"
#import "ThreadUtils.h"
#import "CBXWaiter.h"
#import "CBXMachClock.h"
#import "CBXConstants.h"
#import "CBXException.h"
#import "CBXMachClock.h"
#import "JSONUtils.h"

@interface Application ()
@property (nonatomic, strong) XCUIApplication *app;
@end

@implementation Application
static Application *currentApplication;

+ (void)load {
    static dispatch_once_t oncet;
    dispatch_once(&oncet, ^{
        currentApplication = [self new];
    });
}

+ (BOOL)hasSession {
    return [currentApplication hasSession];
}

+ (XCUIApplication *)currentApplication {
    return currentApplication.app;
}

- (BOOL)hasSession {
    return self.app.exists;
}

- (void)startSession {
    DDLogDebug(@"Launching application '%@'", self.app.bundleID);

    __block NSError *outerError = nil;
    [ThreadUtils runSync:^(BOOL *setToTrueWhenDone) {
        [[Testmanagerd get] _XCT_launchApplicationWithBundleID:self.app.bundleID
                                                     arguments:self.app.launchArguments
                                                   environment:self.app.launchEnvironment
                                                    completion:^(NSError *innerError) {
                                                        outerError = innerError;
                                                        *setToTrueWhenDone = YES;
                                                    }];
    }];

    if (outerError) {
        NSString *errorMessage;
        errorMessage = [NSString stringWithFormat:@"Could not launch application with bundle identifier: %@\n%@",
                        self.app.bundleID, outerError.localizedDescription];
        @throw [CBXException withMessage:errorMessage userInfo:nil];
    }
}

+ (XCUIApplicationState)terminateCurrentApplication {
    XCUIApplication *app = currentApplication.app;
    if (!app) {
        DDLogDebug(@"There is no current application");
        return XCUIApplicationStateNotRunning;
    } else {
        return [Application terminateApplication:app];
    }
}

+ (XCUIApplicationState)terminateApplication:(XCUIApplication *)application {
    NSTimeInterval startTime = [[CBXMachClock sharedClock] absoluteTime];
    if (application.state == XCUIApplicationStateNotRunning) {
        DDLogDebug(@"Application %@ is not running", application.identifier);
        return XCUIApplicationStateNotRunning;
    }

    [application terminate];

    [CBXWaiter waitWithTimeout:10
                     untilTrue:^BOOL{
                         return application.state == XCUIApplicationStateNotRunning;
                     }];
    NSTimeInterval elapsed = [[CBXMachClock sharedClock] absoluteTime] - startTime;

    if (application.state != XCUIApplicationStateNotRunning) {
        DDLogDebug(@"Application did not terminate after %@ seconds", @(elapsed));
    } else {
        DDLogDebug(@"Application did terminate after %@ seconds", @(elapsed));
    }

    return application.state;
}

+ (XCUIApplicationState)terminateApplicationWithIdentifier:(NSString *)bundleIdentifier {
    XCUIApplication *application;
    application = [[XCUIApplication alloc] initPrivateWithPath:nil
                                                      bundleID:bundleIdentifier];

    return [Application terminateApplication:application];
}

+ (void)launchBundlePath:(NSString *)bundlePath
                bundleID:(NSString *)bundleID
              launchArgs:(NSArray *)launchArgs
                     env:(NSDictionary *)environment
      terminateIfRunning:(BOOL)terminateIfRunning {

    XCUIApplication *application = [[XCUIApplication alloc] initPrivateWithPath:bundlePath
                                                                       bundleID:bundleID];

    if (terminateIfRunning) {
        [Application terminateApplication:application];
    }


    application.launchArguments = launchArgs ?: @[];
    application.launchEnvironment = environment ?: @{};

    currentApplication.app = application;
    [currentApplication startSession];
}

+ (id)applicationQuery:(XCUIApplication *)xcuiApplication {
    SEL selector = NSSelectorFromString(@"applicationQuery");

    NSMethodSignature *signature;
    Class klass = NSClassFromString(@"XCUIApplication");
    signature = [klass instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation;

    invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = xcuiApplication;
    invocation.selector = selector;

    id applicationQuery = nil;
    void *buffer;
    [invocation invoke];
    [invocation getReturnValue:&buffer];
    applicationQuery = (__bridge id)buffer;
    return applicationQuery;
}

+ (void)resolveSnapshot:(XCUIApplication *)xcuiApplication {
    if ([xcuiApplication lastSnapshot]) {
        DDLogDebug(@"Resolving application snapshot: already has a 'last snapshot'; nothing to do");
        return;
    }

    DDLogDebug(@"Resolving application snapshot: 'last snapshot' does not exist");
    NSTimeInterval start = [[CBXMachClock sharedClock] absoluteTime];

    id applicationQuery = [Application applicationQuery:xcuiApplication];

    Class klass = NSClassFromString(@"XCApplicationQuery");
    SEL selector = NSSelectorFromString(@"elementBoundByIndex:");

    NSMethodSignature *signature;
    signature = [klass instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation;

    invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = applicationQuery;
    invocation.selector = selector;
    NSUInteger index = 0;
    [invocation setArgument:&index atIndex:2];

    XCUIElement *element = nil;
    void *buffer;
    [invocation invoke];
    [invocation getReturnValue:&buffer];
    element = (__bridge XCUIElement *)buffer;

    [element resolve];

    NSTimeInterval end = [[CBXMachClock sharedClock] absoluteTime];
    NSTimeInterval elapsed = end - start;
    DDLogDebug(@"Took %@ seconds to resolve application snapshot", @(elapsed));
}

+ (NSDictionary *)tree {
    XCUIApplication *app = [Application currentApplication];
    [XCUIApplication cbxResolveSnapshot:app];
    return [Application snapshotTree:[app lastSnapshot]];
}

+ (NSDictionary *)snapshotTree:(XCElementSnapshot *)snapshot {
    NSMutableDictionary *json = [JSONUtils snapshotOrElementToJSON:snapshot];

    if (snapshot.children.count) {
        NSMutableArray *children = [NSMutableArray array];
        for (XCElementSnapshot *child in snapshot.children) {
            [children addObject:[self snapshotTree:child]];
        }
        json[@"children"] = children;
    }
    return json;
}

@end

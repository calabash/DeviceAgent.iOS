
#import "Application.h"
#import "CBX-XCTest-Umbrella.h"
#import "XCTest+CBXAdditions.h"
#import "Testmanagerd.h"
#import "ThreadUtils.h"
#import "CBXWaiter.h"
#import "CBXMachClock.h"
#import "CBXConstants.h"
#import "CBXException.h"

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

@end

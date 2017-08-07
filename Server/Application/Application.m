
#import "ElementNotFoundException.h"
#import "Application.h"
#import "Testmanagerd.h"
#import "ThreadUtils.h"
#import "CBXWaiter.h"
#import "CBXMachClock.h"

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

+ (BOOL)applicationIsInstalled:(NSString *)bundleIdentifier {
    XCUIApplication *app = [[XCUIApplication alloc] initPrivateWithPath:nil
                                                               bundleID:bundleIdentifier];
    return [app exists];
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

+ (void)killCurrentApplication {
   if (!currentApplication.app) {
       DDLogDebug(@"There is no current application");
   } else {
       [Application killApplicationWithBundleIdentifier:[currentApplication.app bundleID]];
   }
}

+ (void)killApplicationWithBundleIdentifier:(NSString *)bundleIdentifier {
    XCUIApplication *application = [[XCUIApplication alloc] initPrivateWithPath:nil
                                                                       bundleID:bundleIdentifier];

    if (application.state == XCUIApplicationStateNotRunning) {
        DDLogDebug(@"Application %@ is not running", bundleIdentifier);
        return;
    }

    NSTimeInterval startTime = [[CBXMachClock sharedClock] absoluteTime];
    __block NSError *outerError = nil;
    [ThreadUtils runSync:^(BOOL *setToTrueWhenDone) {
      [[Testmanagerd get] _XCT_terminateApplicationWithBundleID:bundleIdentifier
                                                     completion:^(NSError *innerError) {
                                                       outerError = innerError;
                                                       *setToTrueWhenDone = YES;
                                                     }];
    }];

    if (outerError) {
        NSString *message;
        message = [NSString stringWithFormat:@"Could not terminate application with bundle identifier: %@\n%@",
                                             bundleIdentifier, outerError.localizedDescription];
        @throw [CBXException withMessage:message userInfo:nil];
    } else {
        [CBXWaiter waitWithTimeout:10
                         untilTrue:^BOOL{
                             return application.state == XCUIApplicationStateNotRunning;
                         }];
    }

    NSTimeInterval elapsed = [[CBXMachClock sharedClock] absoluteTime] - startTime;

    if (application.state != XCUIApplicationStateNotRunning) {
        DDLogDebug(@"Application did not terminate after %@ seconds", @(elapsed));
    } else {
        DDLogDebug(@"Application did terminate after %@ seconds", @(elapsed));
    }
}

+ (void)launchBundlePath:(NSString *)bundlePath
                bundleID:(NSString *)bundleID
              launchArgs:(NSArray *)launchArgs
                     env:(NSDictionary *)environment
      terminateIfRunning:(BOOL)terminateIfRunning {

    if (terminateIfRunning) {
        [Application killApplicationWithBundleIdentifier:bundleID];
    }

    XCUIApplication *application = [[XCUIApplication alloc] initPrivateWithPath:bundlePath
                                                                       bundleID:bundleID];

    application.launchArguments = launchArgs ?: @[];
    application.launchEnvironment = environment ?: @{};

    currentApplication.app = application;
    [currentApplication startSession];
}

@end

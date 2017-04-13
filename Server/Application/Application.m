//
//  CBApplication.m
//  xcuitest-server
//

#import "ElementNotFoundException.h"
#import "XCUICoordinate.h"
#import "Application.h"
#import "Testmanagerd.h"
#import "XCUIElement.h"
#import "ThreadUtils.h"
#import "CBXWaiter.h"
#import "CBXMachClock.h"

@interface Application ()
@property (nonatomic, strong) XCUIApplication *app;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, XCUIElement *> *elementCache;
@end

@implementation Application
static Application *currentApplication;
static NSInteger currentElementIndex = 0;

+ (void)load {
    static dispatch_once_t oncet;
    dispatch_once(&oncet, ^{
        currentApplication = [self new];
        currentApplication.elementCache = [NSMutableDictionary new];
    });
}

+ (BOOL)hasSession {
    return [currentApplication hasSession];
}

+ (XCUIApplication *)currentApplication {
    return currentApplication.app;
}

+ (NSNumber *)cacheElement:(XCUIElement  * _Nonnull)el {
    currentApplication.elementCache[@(currentElementIndex)] = el;
    return @(currentElementIndex++);
}

+ (XCUIElement *)cachedElement:(NSNumber *_Nonnull)index {
    return currentApplication.elementCache[index];
}

+ (XCUIElement *)cachedElementOrThrow:(NSNumber *)index {
    XCUIElement *el = [self cachedElement:index];
    if (el == nil) {
        @throw [ElementNotFoundException withMessage:[NSString stringWithFormat:@"No element found with test_id %@", index]];
    }
    return el;
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

    if (application.state == CBXCApplicationStateNotRunning) {
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
                           return application.state == CBXCApplicationStateNotRunning;
                         }];
    }

    NSTimeInterval elapsed = [[CBXMachClock sharedClock] absoluteTime] - startTime;

    if (application.state != CBXCApplicationStateNotRunning) {
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

    // TODO: This seems to crash/end the test session...
    //    if ([currentApplication hasSession]) {
    //        [currentApplication kill];
    //    }

    currentApplication.app = [[XCUIApplication alloc] initPrivateWithPath:bundlePath
                                                                 bundleID:bundleID];
    currentApplication.app.launchArguments = launchArgs ?: @[];
    currentApplication.app.launchEnvironment = environment ?: @{};

    [currentApplication startSession];
}

@end

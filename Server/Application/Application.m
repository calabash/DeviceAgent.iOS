//
//  CBApplication.m
//  xcuitest-server
//

#import "ElementNotFoundException.h"
#import "XCUICoordinate.h"
#import "Application.h"
#import "Testmanagerd.h"
#import "XCUIElement.h"

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

- (void)kill {
    NSLog(@"Killing application '%@'", self.app.bundleID);
    [self.app terminate];
    self.app = nil;
}

- (void)startSession {
    NSLog(@"Launching application '%@'", self.app.bundleID);

    [[Testmanagerd get] _XCT_launchApplicationWithBundleID:self.app.bundleID
                                                 arguments:self.app.launchArguments
                                               environment:self.app.launchEnvironment
                                                completion:^(NSError *innerError) {
                                                    if (innerError) {
                                                        // This is async call.
                                                        //
                                                        // An @throw will never result in a HTTP error response.
                                                        //
                                                        // It is not possible to capture the innerError in
                                                        // a local variable.
                                                    }
                                                }];
}

+ (void)killCurrentApplication {
    //TODO: This may throw an exception that ends the test.
    //https://forums.developer.apple.com/message/59121
    [currentApplication kill];
}

+ (void)launchBundlePath:(NSString *)bundlePath
                bundleID:(NSString *)bundleID
              launchArgs:(NSArray *)launchArgs
                     env:(NSDictionary *)environment {

    // TODO: This seems to crash/end the test session...
    //    if ([currentApplication hasSession]) {
    //        [currentApplication kill];
    //    }

    currentApplication.app = [[XCUIApplication alloc] initPrivateWithPath:bundlePath
                                                                 bundleID:bundleID];
    currentApplication.app.launchArguments = launchArgs ?: @[];
    currentApplication.app.launchEnvironment = environment ?: @{};

    [currentApplication startSession];

    NSDate *startDate = [NSDate date];
    BOOL running = NO;
    NSUInteger count = 1;
    NSUInteger tries = 30;
    CFTimeInterval interval = 1.0;
    while (!running && count <= tries) {
        NSLog(@"Waiting for application to launch: try %@ of %@", @(count), @(tries));
        running = [[Application currentApplication] running];
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, interval, false);
        count = count + 1;
    }

    NSTimeInterval elapsed = ABS([startDate timeIntervalSinceDate:[NSDate date]]);
    if (!running) {
        NSString *errorMsg;
        errorMsg = [NSString stringWithFormat:@"Application %@ could not launch after %@ seconds",
                    bundleID, @(elapsed)];
        @throw [CBXException withMessage:errorMsg userInfo:nil];
    } else {
        NSLog(@"Took %@ seconds to launch %@", @(elapsed), bundleID);
    }
}

@end

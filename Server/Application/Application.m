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
    
    //TODO: This seems to crash/end the test session... 
//    if ([currentApplication hasSession]) {
//        [currentApplication kill];
//    }
    
    currentApplication.app = [[XCUIApplication alloc] initPrivateWithPath:bundlePath bundleID:bundleID];
    currentApplication.app.launchArguments = launchArgs ?: @[];
    currentApplication.app.launchEnvironment = environment ?: @{};
    
    [currentApplication startSession];
}

@end

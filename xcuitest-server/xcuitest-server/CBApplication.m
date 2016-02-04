//
//  CBApplication.m
//  xcuitest-server
//

#import "XCUICoordinate.h"
#import "CBApplication.h"
#import "XCUIElement.h"

@interface CBApplication ()
@property (nonatomic, strong) XCUIApplication *app;
@end

@implementation CBApplication
static CBApplication *currentApplication;

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
    /*
     * The application is apparently somewhat lazily instantiated.
     * Calling `resolve` grabs a current snapshot of the app. 
     *
     * TODO: ensure that the app is always resolved before a query
     */
    [currentApplication.app resolve];
    
    return currentApplication.app;
}

- (BOOL)hasSession {
    return self.app.exists;
}

- (void)kill {
    NSLog(@"Killing application '%@'", self.app.bundleID);
    [self.app terminate];
    [self.app _waitForQuiescence];
    self.app = nil;
}

- (void)startSession {
    NSLog(@"Launching application '%@'", self.app.bundleID);
    [self.app launch];
}

+ (void)launchBundlePath:(NSString *)bundlePath
                      bundleID:(NSString *)bundleID
                    launchArgs:(NSArray *)launchArgs
                           env:(NSDictionary *)environment{
    
    if ([currentApplication hasSession]) {
        [currentApplication kill];
    }
    
    currentApplication.app = [[XCUIApplication alloc] initPrivateWithPath:bundlePath bundleID:bundleID];
    currentApplication.app.launchArguments = launchArgs ?: @[];
    currentApplication.app.launchEnvironment = environment ?: @{};
    
    [currentApplication startSession];
}

+ (void)launchBundleID:(NSString *)bundleID
                  launchArgs:(NSArray *)launchArgs
                         env:(NSDictionary *)environment {
    [self launchBundlePath:nil
                  bundleID:bundleID
                launchArgs:launchArgs
                       env:environment];
}

@end

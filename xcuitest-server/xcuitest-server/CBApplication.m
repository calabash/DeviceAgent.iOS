//
//  CBApplication.m
//  xcuitest-server
//

#import "XCUICoordinate.h"
#import "CBApplication.h"

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
    return currentApplication.app;
}

- (BOOL)hasSession {
    return self.app.exists;
}

- (void)kill {
    NSLog(@"Killing application '%@'", self.app.bundleID);
    [self.app.application terminate];
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

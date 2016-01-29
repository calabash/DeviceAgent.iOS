//
//  CBApplication.m
//  xcuitest-server
//
//  Created by Chris Fuentes on 1/29/16.
//  Copyright © 2016 calabash. All rights reserved.
//

#import "CBApplication.h"
#import "XCUIApplication.h"

@interface CBApplication ()
@property (nonatomic, strong) XCUIApplication *app;
@end

@implementation CBApplication
+ (instancetype)withBundlePath:(NSString *)bundlePath
                      bundleID:(NSString *)bundleID
                    launchArgs:(NSArray *)launchArgs
                           env:(NSDictionary *)environment{
    CBApplication *app = [CBApplication new];
    app.app = [[XCUIApplication alloc] initPrivateWithPath:bundlePath bundleID:bundleID];
    app.app.launchArguments = launchArgs ?: @[];
    app.app.launchEnvironment = environment ?: @{};
    return app;
}

- (void)launch {
    [self.app _launchUsingXcode:NO];
}
@end

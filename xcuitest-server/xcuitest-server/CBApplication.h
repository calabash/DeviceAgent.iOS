//
//  CBApplication.h
//  xcuitest-server
//
//  Created by Chris Fuentes on 1/29/16.
//  Copyright © 2016 calabash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCUIApplication.h"

@interface CBApplication : NSObject
+ (void)launchBundlePath:(NSString *)bundlePath
                bundleID:(NSString *)bundleID
              launchArgs:(NSArray *)launchArgs
                     env:(NSDictionary *)environment;

+ (void)launchBundleID:(NSString *)bundleID
            launchArgs:(NSArray *)launchArgs
                   env:(NSDictionary *)environment;

+ (XCUIApplication *)currentApplication; //TODO: I want to hide this somehow. -CF
+ (BOOL)hasSession;

@end

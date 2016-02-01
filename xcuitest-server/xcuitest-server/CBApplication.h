//
//  CBApplication.h
//  xcuitest-server
//
//  Created by Chris Fuentes on 1/29/16.
//  Copyright © 2016 calabash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBApplication : NSObject
+ (instancetype)withBundlePath:(NSString *)bundlePath
                      bundleID:(NSString *)bundleID
                    launchArgs:(NSArray *)launchArgs
                           env:(NSDictionary *)environment;
- (void)launch;
@end

//
//  SessionRoutes.m
//  xcuitest-server
//
//  Created by Chris Fuentes on 1/29/16.
//  Copyright © 2016 calabash. All rights reserved.
//

#import "CBApplication.h"
#import "SessionRoutes.h"
#import "CBMacros.h"

@implementation SessionRoutes
+ (NSArray <CBRoute *> *)getRoutes {
    return @[
             [CBRoute post:@"/session" withBlock:^(RouteRequest *request, RouteResponse *response) {
                 NSDictionary *json = DATA_TO_JSON(request.body);
                 [[CBApplication withBundlePath:json[@"bundlePath"]
                                       bundleID:json[@"bundleID"]
                                     launchArgs:json[@"launchArgs"]
                                            env:json[@"environment"]] launch];
                 [response respondWithJSON:@{@"status" : @"launching!"}];
             }]
             ];
}
@end

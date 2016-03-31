//
//  MetaRoutes.m
//  xcuitest-server
//
//  Created by Chris Fuentes on 2/9/16.
//  Copyright © 2016 calabash. All rights reserved.
//

#import "MetaRoutes.h"
#import "XCTestDriver.h"
#import "CBApplication.h"

@implementation MetaRoutes
+ (NSArray <CBRoute *> *)getRoutes {
    return @[
             [CBRoute get:@"/sessionIdentifier" withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 NSUUID *testUUID = [XCTestDriver sharedTestDriver].sessionIdentifier;
                 [response respondWithString:[testUUID UUIDString]];
             }],
             [CBRoute get:@"/pid" withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 NSString *pidString = [NSString stringWithFormat:@"%d",
                                        [CBApplication currentApplication].processID];
                 [response respondWithString:pidString];
             }]
             ];
}
@end

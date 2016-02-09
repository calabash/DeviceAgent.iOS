//
//  MetaRoutes.m
//  xcuitest-server
//
//  Created by Chris Fuentes on 2/9/16.
//  Copyright © 2016 calabash. All rights reserved.
//

#import "MetaRoutes.h"
#import "XCTestDriver.h"

@implementation MetaRoutes
+ (NSArray <CBRoute *> *)getRoutes {
    return @[
             [CBRoute get:@"/sessionIdentifier" withBlock:^(RouteRequest *request, RouteResponse *response) {
                 NSUUID *testUUID = [XCTestDriver sharedTestDriver].sessionIdentifier;
                 [response respondWithString:[testUUID UUIDString]];
             }]
             ];
}
@end

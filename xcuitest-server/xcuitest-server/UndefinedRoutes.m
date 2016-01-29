//
//  UndefinedRoutes.m
//  xcuitest-server
//
//  Created by Chris Fuentes on 1/29/16.
//  Copyright © 2016 calabash. All rights reserved.
//

#import "UndefinedRoutes.h"

@implementation UndefinedRoutes
+ (NSArray <CBRoute *> *)getRoutes {
    
    RequestHandler unhandledBlock = ^(RouteRequest *request, RouteResponse *response) {
        [response respondWithString:[NSString stringWithFormat:@"Unhandled endpoint: %@\nParams: %@", request.url, request.params]];
    };
    return @[
             [CBRoute get:@"/*" withBlock:unhandledBlock],
             [CBRoute post:@"/*" withBlock:unhandledBlock],
             [CBRoute put:@"/*" withBlock:unhandledBlock],
             [CBRoute delete:@"/*" withBlock:unhandledBlock],
             ];
}
@end

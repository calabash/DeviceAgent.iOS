//
//  UndefinedRoutes.m
//  xcuitest-server
//
//  Created by Chris Fuentes on 1/29/16.
//  Copyright © 2016 calabash. All rights reserved.
//

#import "UndefinedRoutes.h"

@interface CBRoute (DontAutoregister)
- (instancetype)dontAutoregister;
@end

@implementation CBRoute (DontAutoregister)
- (instancetype)dontAutoregister {
    self.shouldAutoregister = NO;
    return self;
}
@end


@implementation UndefinedRoutes
+ (NSArray <CBRoute *> *)getRoutes {
    
    RequestHandler unhandledBlock = ^(RouteRequest *request, RouteResponse *response) {
        [response respondWithString:[NSString stringWithFormat:@"Unhandled endpoint: %@\nParams: %@", request.url, request.params]];
    };
    return @[
             [CBRoute get:@"/*" withBlock:unhandledBlock].dontAutoregister,
             [CBRoute post:@"/*" withBlock:unhandledBlock].dontAutoregister,
             [CBRoute put:@"/*" withBlock:unhandledBlock].dontAutoregister,
             [CBRoute delete:@"/*" withBlock:unhandledBlock].dontAutoregister,
             ];
}
@end

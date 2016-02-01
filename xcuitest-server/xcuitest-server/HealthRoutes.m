//
//  HealthRoute.m
//  xcuitest-server
//
//  Created by Chris Fuentes on 1/29/16.
//  Copyright © 2016 calabash. All rights reserved.
//

#import "HealthRoutes.h"

@implementation HealthRoutes
+ (NSArray<CBRoute *> *)getRoutes {
    return @[
             [CBRoute get:@"/health" withBlock:^(RouteRequest *request, RouteResponse *response) {
                 [response respondWithString:@"Calabash is ready and waiting."];
             }]
           ];
}
@end

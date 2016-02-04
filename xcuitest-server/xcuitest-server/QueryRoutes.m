//
//  QueryRoutes.m
//  xcuitest-server
//
//  Created by Chris Fuentes on 2/3/16.
//  Copyright © 2016 calabash. All rights reserved.
//

#import "CBApplication+Queries.h"
#import "QueryRoutes.h"

@implementation QueryRoutes
+ (NSArray <CBRoute *> *)getRoutes {
    return @[
             [CBRoute get:@"/tree" withBlock:^(RouteRequest *request, RouteResponse *response) {
                 [response respondWithJSON:[CBApplication tree]];
             }]
             ];
}
@end

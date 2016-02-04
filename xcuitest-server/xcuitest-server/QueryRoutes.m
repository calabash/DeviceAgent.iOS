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
             }],
             
             [CBRoute get:@"/query/marked/:text" withBlock:^(RouteRequest *request, RouteResponse *response) {
                 NSString *text = request.params[@"text"];
                 [response respondWithJSON:[CBApplication elementsMarked:text]];
             }],
             
             [CBRoute get:@"/query/id/:id" withBlock:^(RouteRequest *request, RouteResponse *response) {
                 NSString *identifier = request.params[@"id"];
                 [response respondWithJSON:[CBApplication elementsWithID:identifier]];
             }],
             ];
}
@end

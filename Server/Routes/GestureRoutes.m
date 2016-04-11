//
//  GestureRotues.m
//  xcuitest-server
//

#import "GestureFactory.h"
#import "GestureRoutes.h"
#import "CBXConstants.h"
#import "JSONUtils.h"
#import "CBXMacros.h"

@implementation GestureRoutes
+ (NSArray<CBXRoute *> *)getRoutes {
    return @[
             [CBXRoute post:@"/1.0/gesture" withBlock:^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {
                 [GestureFactory executeGestureWithJSON:body
                                               completion:^(NSError *e) {
                       if (e) {
                           [response respondWithJSON:@{ @"error" : e.localizedDescription }]; //should never execute
                       } else {
                           [response respondWithJSON:@{ @"status" : @"success" }];
                       }
                 }];
             }]
             ];
}


@end

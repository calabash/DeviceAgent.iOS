//
//  GestureRotues.m
//  xcuitest-server
//

#import "CBGestureFactory.h"
#import "GestureRoutes.h"
#import "CBConstants.h"
#import "JSONUtils.h"
#import "CBMacros.h"

@implementation GestureRoutes
+ (NSArray<CBRoute *> *)getRoutes {
    return @[
             [CBRoute post:@"/1.0/gesture" withBlock:^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {
                 [CBGestureFactory executeGestureWithJSON:body completion:^(NSError *e) {
                     if (e) {
                         [response respondWithJSON:@{ @"error" : e.localizedDescription }];
                     } else {
                         [response respondWithJSON:@{ @"status" : @"success" }];
                     }
                 }];
             }]
             ];
}


@end

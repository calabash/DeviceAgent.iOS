//
//  HealthRoute.m
//  xcuitest-server
//

#import "HealthRoutes.h"

@implementation HealthRoutes
+ (NSArray<CBRoute *> *)getRoutes {
    return @[
             [CBRoute get:@"/health" withBlock:^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {
                 [response respondWithJSON:@{
                                             @"status" : @"Calabash is ready and waiting."
                                             }];
             }],
             
             [CBRoute get:@"/ping" withBlock:^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {
                 [response respondWithJSON:@{
                                             @"status" : @"honk"
                                             }];
             }],
           ];
}
@end

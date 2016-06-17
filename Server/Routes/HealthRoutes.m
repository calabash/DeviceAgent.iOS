//
//  HealthRoute.m
//  xcuitest-server
//

#import "HealthRoutes.h"

@implementation HealthRoutes
+ (NSArray<CBXRoute *> *)getRoutes {
    return @[
             [CBXRoute get:@"/health" withBlock:^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {
                 [response respondWithJSON:@{
                                             @"status" : @"Calabash is ready and waiting."
                                             }];
             }],
             
             [CBXRoute get:@"/ping" withBlock:^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {
                 [response respondWithJSON:@{
                                             @"status" : @"honk"
                                             }];
             }],
             
             [CBXRoute get:@"/status" withBlock:^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {
                 [response respondWithJSON:@{
                                             @"status" : @"DeviceAgent is ready and waiting."
                                             }];
             }],
           ];
}
@end

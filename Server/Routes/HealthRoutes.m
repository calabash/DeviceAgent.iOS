//
//  HealthRoute.m
//  xcuitest-server
//

#import "CBXMacros.h"
#import "HealthRoutes.h"

@implementation HealthRoutes
+ (NSArray<CBXRoute *> *)getRoutes {
    return @[
             [CBXRoute get:endpoint(@"/health", 1.0) withBlock:^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {
                 [response respondWithJSON:@{
                                             @"status" : @"Calabash is ready and waiting."
                                             }];
             }],
             
             [CBXRoute get:endpoint(@"/ping", 1.0) withBlock:^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {
                 [response respondWithJSON:@{
                                             @"status" : @"honk"
                                             }];
             }],
             
             [CBXRoute get:endpoint(@"/status", 1.0) withBlock:^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {
                 [response respondWithJSON:@{
                                             @"status" : @"DeviceAgent is ready and waiting."
                                             }];
             }],
           ];
}
@end

//
//  HealthRoute.m
//  xcuitest-server
//

#import "HealthRoutes.h"

@implementation HealthRoutes
+ (NSArray<CBRoute *> *)getRoutes {
    return @[
             [CBRoute get:@"/health" withBlock:^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {
                 [response respondWithString:@"Calabash is ready and waiting."];
             }],
             
             [CBRoute get:@"/ping" withBlock:^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {
                 [response respondWithString:@"honk"];
             }],
           ];
}
@end

//
//  HealthRoute.m
//  xcuitest-server
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

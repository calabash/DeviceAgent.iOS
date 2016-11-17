
#import "CBXMacros.h"
#import "Testmanagerd.h"
#import "HealthRoutes.h"

@implementation HealthRoutes
+ (NSArray<CBXRoute *> *)getRoutes {
    return @[
             [CBXRoute get:endpoint(@"/health", 1.0) withBlock:^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {
                 [response respondWithJSON:@{
                                             @"status" : @"Calabash is ready and waiting."
                                             }];
             }],
             
             [CBXRoute get:endpoint(@"/testmanagerd-health", 1.0) withBlock:^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {
                 if ([Testmanagerd hasValidConnection]) {
                     [response respondWithJSON:@{
                                                 @"status" : @"Ready for orders"
                                                }];
                 } else {
                     [response respondWithJSON:@{
                                                 @"error" : @"Connection invalid",
                                                 @"reason" : [Testmanagerd invalidationReason]
                                                 }];
                 }
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

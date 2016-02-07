//
//  QueryRoutes.m
//  xcuitest-server
//

#import "CBApplication+Queries.h"
#import "QueryRoutes.h"
#import "CBConstants.h"

@implementation QueryRoutes
+ (NSArray <CBRoute *> *)getRoutes {
    return @[
             [CBRoute get:@"/tree" withBlock:^(RouteRequest *request, RouteResponse *response) {
                 [response respondWithJSON:[CBApplication tree]];
             }],
             
             [CBRoute get:@"/query/marked/:text" withBlock:^(RouteRequest *request, RouteResponse *response) {
                 NSString *text = request.params[CB_TEXT_KEY];
                 [response respondWithJSON:[CBApplication jsonForElementsMarked:text]];
             }],
             
             [CBRoute get:@"/query/id/:id" withBlock:^(RouteRequest *request, RouteResponse *response) {
                 NSString *identifier = request.params[CB_IDENTIFIER_KEY];
                 [response respondWithJSON:[CBApplication jsonForElementsWithID:identifier]];
             }],
             
             [CBRoute get:@"/query/type/:type" withBlock:^(RouteRequest *request, RouteResponse *response) {
                 NSString *type = request.params[CB_TYPE_KEY];
                 [response respondWithJSON:[CBApplication jsonForElementsWithType:type]];
             }],
             ];
}
@end

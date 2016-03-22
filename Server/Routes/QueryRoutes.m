//
//  QueryRoutes.m
//  xcuitest-server
//

#import "CBApplication+Queries.h"
#import "CBQuery.h"
#import "QueryRoutes.h"
#import "CBConstants.h"

@implementation QueryRoutes
+ (NSArray <CBRoute *> *)getRoutes {
    return @[
             [CBRoute get:@"/1.0/tree" withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 [response respondWithJSON:[CBApplication tree]];
             }],
             
             [CBRoute post:@"/1.0/gesture" withBlock:^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {

             }],
             
             [CBRoute get:@"/query/marked/:text" withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 NSString *text = request.params[CB_TEXT_KEY];
                 //TODO: look for text in request.body
                 [response respondWithJSON:[CBApplication jsonForElementsMarked:text]];
             }],
             
             [CBRoute get:@"/query/id/:id" withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 NSString *identifier = request.params[CB_IDENTIFIER_KEY];
                 [response respondWithJSON:[CBApplication jsonForElementsWithID:identifier]];
             }],
             
             [CBRoute get:@"/query/type/:type" withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 NSString *type = request.params[CB_TYPE_KEY];
                 [response respondWithJSON:[CBApplication jsonForElementsWithType:type]];
             }],
             
             
             ];
}
@end

//
//  QueryRoutes.m
//  xcuitest-server
//

#import "CBApplication+Queries.h"
#import "QueryRoutes.h"
#import "CBConstants.h"
#import "JSONUtils.h"
#import "CBQuery.h"

@implementation QueryRoutes
+ (NSArray <CBRoute *> *)getRoutes {
    return @[
             [CBRoute get:@"/1.0/tree" withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 [response respondWithJSON:[CBApplication tree]];
             }],
             
             [CBRoute post:@"/1.0/query" withBlock:^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {
                 QueryConfiguration *queryConfig = [QueryConfiguration withJSON:body
                                                                      validator:[CBQuery validator]];
                 CBQuery *query = [CBQuery withQueryConfiguration:queryConfig];
                 
                 NSArray <XCUIElement *> *elements = [query execute];
                 
                 /*
                    Format and return the results
                  */
                 NSMutableArray *results = [NSMutableArray arrayWithCapacity:elements.count];
                 for (XCUIElement *el in elements) {
                     NSDictionary *json = [JSONUtils snapshotToJSON:el];
                     [results addObject:json];
                 }
                 
                 [response respondWithJSON:@{@"result" : results}];
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

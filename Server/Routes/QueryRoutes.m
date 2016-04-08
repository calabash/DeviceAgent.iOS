//
//  QueryRoutes.m
//  xcuitest-server
//

#import "Application+Queries.h"
#import "QueryRoutes.h"
#import "CBXConstants.h"
#import "JSONUtils.h"
#import "Query.h"

@implementation QueryRoutes
+ (NSArray <CBXRoute *> *)getRoutes {
    return @[
             [CBXRoute get:@"/1.0/tree" withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 [response respondWithJSON:[Application tree]];
             }],
             
             [CBXRoute post:@"/1.0/query" withBlock:^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {
                 QueryConfiguration *queryConfig = [QueryConfiguration withJSON:body
                                                                      validator:[Query validator]];
                 Query *query = [Query withQueryConfiguration:queryConfig];
                 
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
             
             [CBXRoute get:@"/query/marked/:text" withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 NSString *text = request.params[CBX_TEXT_KEY];
                 //TODO: look for text in request.body
                 [response respondWithJSON:[Application jsonForElementsMarked:text]];
             }],
             
             [CBXRoute get:@"/query/id/:id" withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 NSString *identifier = request.params[CBX_IDENTIFIER_KEY];
                 [response respondWithJSON:[Application jsonForElementsWithID:identifier]];
             }],
             
             [CBXRoute get:@"/query/type/:type" withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 NSString *type = request.params[CBX_TYPE_KEY];
                 [response respondWithJSON:[Application jsonForElementsWithType:type]];
             }],
             
             
             ];
}
@end

//
//  QueryRoutes.m
//  xcuitest-server
//

#import "QueryConfigurationFactory.h"
#import "Application+Queries.h"
#import "CBXConstants.h"
#import "QueryFactory.h"
#import "QueryRoutes.h"
#import "JSONUtils.h"
#import "Query.h"

@implementation QueryRoutes
+ (NSArray <CBXRoute *> *)getRoutes {
    return @[
             [CBXRoute get:endpoint(@"/tree", 1.0) withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 [response respondWithJSON:[Application tree]];
             }],
             
             [CBXRoute post:endpoint(@"/query", 1.0) withBlock:^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {
                 QueryConfiguration *queryConfig = [QueryConfigurationFactory configWithJSON:body
                                                                                   validator:[Query validator]];
                 Query *query = [QueryFactory queryWithQueryConfiguration:queryConfig];
                 
                 NSArray <XCUIElement *> *elements = [query execute];
                 
                 /*
                    Format and return the results
                  */
                 NSMutableArray *results = [NSMutableArray arrayWithCapacity:elements.count];
                 for (XCUIElement *el in elements) {
                     [Application cacheElement:el];
                     NSDictionary *json = [JSONUtils snapshotToJSON:el];
                     [results addObject:json];
                 }
                 
                 [response respondWithJSON:@{@"result" : results}];
             }],
             
             [CBXRoute get:endpoint(@"/query/marked/:text", 1.0) withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 NSString *text = request.params[CBX_TEXT_KEY];
                 //TODO: look for text in request.body
                 [response respondWithJSON:[Application jsonForElementsMarked:text]];
             }],
             
             [CBXRoute get:endpoint(@"/query/id/:id", 1.0) withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 NSString *identifier = request.params[CBX_IDENTIFIER_KEY];
                 [response respondWithJSON:[Application jsonForElementsWithID:identifier]];
             }],
             
             [CBXRoute get:endpoint(@"/query/test_id/:test_id", 1.0) withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 NSNumber *identifier = @([request.params[CBX_TEST_ID_KEY] integerValue]);
                 XCUIElement *el = [Application cachedElementOrThrow:identifier];
                 [response respondWithJSON:[JSONUtils elementToJSON:el]];
             }],
             
             [CBXRoute get:endpoint(@"/query/type/:type", 1.0) withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 NSString *type = request.params[CBX_TYPE_KEY];
                 [response respondWithJSON:[Application jsonForElementsWithType:type]];
             }],
             
             
             ];
}
@end

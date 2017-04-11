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
#import "SpringBoard.h"

@implementation QueryRoutes
+ (NSArray <CBXRoute *> *)getRoutes {
    return @[
             [CBXRoute get:endpoint(@"/tree", 1.0) withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 [[SpringBoard application] handleAlertsOrThrow];
                 [response respondWithJSON:[Application tree]];
             }],

             [CBXRoute post:endpoint(@"/query", 1.0) withBlock:^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {
                 [[SpringBoard application] handleAlertsOrThrow];
                 QueryConfiguration *queryConfig = [QueryConfigurationFactory configWithJSON:body
                                                                                   validator:[Query validator]];
                 Query *query = [QueryFactory queryWithQueryConfiguration:queryConfig];

                 NSArray <XCUIElement *> *elements = [query execute];

                 /*
                    Format and return the results
                  */
                 NSMutableArray *results = [NSMutableArray arrayWithCapacity:elements.count];
                 for (XCUIElement *el in elements) {
                     NSDictionary *json = [JSONUtils snapshotOrElementToJSON:el];
                     [results addObject:json];
                 }
                 [response respondWithJSON:@{@"result" : results}];
             }],

             [CBXRoute get:endpoint(@"/springboard-alert", 1.0) withBlock:^(RouteRequest *request,
                                                                            NSDictionary *data,
                                                                            RouteResponse *response) {
                 XCUIElement *alert = [[SpringBoard application] queryForAlert];
                 NSDictionary *results;

                 if (alert && alert.exists) {
                     NSString *alertTitle = alert.label;
                     XCUIElementQuery *query = [alert descendantsMatchingType:XCUIElementTypeButton];
                     NSArray<XCUIElement *> *buttons = [query allElementsBoundByIndex];

                     NSMutableArray *mutable = [NSMutableArray arrayWithCapacity:buttons.count];

                     for (XCUIElement *button in buttons) {
                         if (button.exists) {
                             NSString *name = button.label;
                             if (name) {
                                 [mutable addObject:name];
                             }
                         }
                     }

                     NSArray *alertButtonTitles = [NSArray arrayWithArray:mutable];
                     NSMutableDictionary *alertJSON;
                     alertJSON = [NSMutableDictionary dictionaryWithDictionary:[JSONUtils elementToJSON:alert]];
                     alertJSON[@"is_springboard_alert"] = @(YES);
                     alertJSON[@"button_titles"] = alertButtonTitles;
                     alertJSON[@"alert_title" ] = alertTitle;

                     results = [NSDictionary dictionaryWithDictionary:alertJSON];
                 } else {
                     results = @{};
                 }

                 [response respondWithJSON:results];
             }],

             [CBXRoute get:endpoint(@"/query/id/:id", 1.0) withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 NSString *identifier = request.params[CBX_IDENTIFIER_KEY];
                 [response respondWithJSON:[Application jsonForElementsWithID:identifier]];
             }],

             [CBXRoute get:endpoint(@"/query/type/:type", 1.0) withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 NSString *type = request.params[CBX_TYPE_KEY];
                 [response respondWithJSON:[Application jsonForElementsWithType:type]];
             }],


             ];
}
@end

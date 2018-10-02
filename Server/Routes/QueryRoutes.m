
#import "QueryRoutes.h"
#import "CBX-XCTest-Umbrella.h"
#import "XCTest+CBXAdditions.h"
#import "QueryConfigurationFactory.h"
#import "Application.h"
#import "CBXConstants.h"
#import "QueryFactory.h"
#import "JSONUtils.h"
#import "Query.h"
#import "SpringBoard.h"
#import "CBXOrientation.h"
#import "CBXMacros.h"
#import "CBXRoute.h"
#import "CBXException.h"

@implementation QueryRoutes
+ (NSArray <CBXRoute *> *)getRoutes {
    return
    @[
      [CBXRoute get:endpoint(@"/tree", 1.0) withBlock:^(RouteRequest *request,
                                                        NSDictionary *data,
                                                        RouteResponse *response) {
          [[SpringBoard application] handleAlertsOrThrow];
          [response respondWithJSON:[Application tree]];
      }],

      [CBXRoute post:endpoint(@"/query", 1.0) withBlock:^(RouteRequest *request,
                                                          NSDictionary *body,
                                                          RouteResponse *response) {
          [[SpringBoard application] handleAlertsOrThrow];
          QueryConfiguration *config;
          config = [QueryConfigurationFactory configWithJSON:body
                                                   validator:[Query validator]];
          Query *query = [QueryFactory queryWithQueryConfiguration:config];

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
              alertJSON = [NSMutableDictionary dictionaryWithDictionary:[JSONUtils snapshotOrElementToJSON:alert]];
              alertJSON[@"is_springboard_alert"] = @(YES);
              alertJSON[@"button_titles"] = alertButtonTitles;
              alertJSON[@"alert_title" ] = alertTitle;

              results = [NSDictionary dictionaryWithDictionary:alertJSON];
          } else {
              results = @{};
          }

          [response respondWithJSON:results];
      }],

      [CBXRoute get:endpoint(@"/orientations", 1.0) withBlock:^(RouteRequest *request,
                                                                NSDictionary *data,
                                                                RouteResponse *response) {
          [response respondWithJSON:[CBXOrientation orientations]];
      }],

      [CBXRoute get:endpoint(@"/element-types", 1.0) withBlock:^(RouteRequest *request,
                                                                 NSDictionary *data,
                                                                 RouteResponse *response) {
          [response respondWithJSON:@{ @"types": [JSONUtils elementTypes] }];
      }]
      ];
}

@end

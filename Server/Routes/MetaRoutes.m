
#import "MetaRoutes.h"
#import "CBX-XCTest-Umbrella.h"
#import "XCTest+CBXAdditions.h"
#import "XCTestConfiguration.h"
#import "Application.h"
#import "CBXMacros.h"
#import "CBXDevice.h"
#import "CBXInfoPlist.h"
#import "SpringBoard.h"
#import "InvalidArgumentException.h"
#import "CBXConstants.h"
#import "CBXRoute.h"

@implementation MetaRoutes
+ (NSArray <CBXRoute *> *)getRoutes {
    return @[
             [CBXRoute get:endpoint(@"/sessionIdentifier", 1.0) withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {

                 NSUUID *testUUID = [[XCTestConfiguration activeTestConfiguration] sessionIdentifier];

                 if (testUUID) {
                     [response respondWithJSON:@{@"sessionId" : [testUUID UUIDString]}];
                 } else {
                     [response respondWithJSON:@{@"sessionId" : [NSNull null]}];
                 }
             }],

             [CBXRoute post:endpoint(@"/terminate", 1.0)
                  withBlock:^(RouteRequest *request,
                              NSDictionary *data,
                              RouteResponse *response) {
                      NSString *bundleIdentifier = data[CBX_BUNDLE_ID_KEY];
                      XCUIApplicationState state;
                      state = [Application terminateApplicationWithIdentifier:bundleIdentifier];
                      [response respondWithJSON:@{@"state" : @(state)}];
                  }],

             [CBXRoute post:endpoint(@"/pid", 1.0) withBlock:^(RouteRequest *request,
                                                               NSDictionary *data,
                                                               RouteResponse *response) {
                 NSString *identifier = data[CBX_BUNDLE_ID_KEY];

                 if (!identifier) {
                     @throw [CBXException withFormat:@"Missing required key '%@' in"
                             "request body: %@",
                             CBX_BUNDLE_ID_KEY, data];
                 }

                 XCUIApplication *application;
                 application = [[XCUIApplication alloc] initPrivateWithPath:nil
                                                                   bundleID:identifier];
                 NSString *pid;
                 if (application) {
                     pid = [NSString stringWithFormat:@"%@", @(application.processID)];
                 } else {
                     pid = [NSString stringWithFormat:@"%@", @(-1)];
                 }

                 [response respondWithJSON:@{@"pid" : pid}];
             }],

             [CBXRoute get:endpoint(@"/device", 1.0) withBlock:^(RouteRequest *request,
                                                                 NSDictionary *data,
                                                                 RouteResponse *response) {
                 NSDictionary *json = [[CBXDevice sharedDevice]
                                       dictionaryRepresentation];
                 [response respondWithJSON:json];
             }],

             [CBXRoute get:endpoint(@"/version", 1.0) withBlock:^(RouteRequest *request,
                                                                  NSDictionary *data,
                                                                  RouteResponse *response) {
                 CBXInfoPlist *plist = [CBXInfoPlist new];
                 [response respondWithJSON:[plist versionInfo]];
             }],

             [CBXRoute get:endpoint(@"/arguments", 1.0) withBlock:^(RouteRequest *request,
                                                                    NSDictionary *data,
                                                                    RouteResponse *response) {
                 NSArray *aut_arguments = @[];
                 if ([Application currentApplication]) {
                     aut_arguments = [[Application currentApplication] launchArguments];
                 }

                 NSArray *device_agent_arguments;
                 device_agent_arguments = [[NSProcessInfo processInfo] arguments];

                 NSDictionary *json;
                 json = @{
                          @"aut_arguments" : aut_arguments,
                          @"device_agent_arguments" : device_agent_arguments };

                 [response respondWithJSON:json];
             }],

             [CBXRoute post:endpoint(@"/set-dismiss-springboard-alerts-automatically", 1.0)
                  withBlock:^(RouteRequest *request,
                              NSDictionary *body,
                              RouteResponse *response) {

                      NSString *key = @"dismiss_automatically";
                      NSNumber *valueFromBody = body[key];
                      if (!valueFromBody) {
                          NSString *message;
                          message = [NSString stringWithFormat:@"Request body is missing"
                                     "required key: '%@'", key];
                          @throw [InvalidArgumentException withMessage:message
                                                              userInfo:@{@"received_body" : body}];

                      }

                      [SpringBoard application].shouldDismissAlertsAutomatically = [valueFromBody boolValue];
                      BOOL value = [[SpringBoard application] shouldDismissAlertsAutomatically];
                      NSDictionary *json = @{@"is_dismissing_alerts_automatically" : @(value)};
                      [response respondWithJSON:json];
                  }]
             ];
}

@end

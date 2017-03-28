
#import "MetaRoutes.h"
#import "XCTestDriver.h"
#import "XCTestConfiguration.h"
#import "Application.h"
#import "CBXMacros.h"
#import "CBXDevice.h"
#import "CBXInfoPlist.h"
#import "SpringBoard.h"
#import "InvalidArgumentException.h"

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

             [CBXRoute get:endpoint(@"/pid", 1.0) withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 NSString *pidString = [NSString stringWithFormat:@"%d",
                                        [Application currentApplication].processID];
                 [response respondWithJSON:@{@"pid" : pidString}];
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

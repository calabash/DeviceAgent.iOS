
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
#import "XCTest+CBXAdditions.h"
#import "XCTest/XCUIProtectedResource.h"

static NSDictionary *protectedResources = nil;

@implementation MetaRoutes
+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // XCUIProtectedResource.h
        protectedResources = @{
            @"Contacts" : [NSNumber numberWithInt:XCUIProtectedResourceContacts],
            @"Calendar" : [NSNumber numberWithInt:XCUIProtectedResourceCalendar],
            @"Reminders" : [NSNumber numberWithInt:XCUIProtectedResourceReminders],
            @"Photos" : [NSNumber numberWithInt:XCUIProtectedResourcePhotos],
            @"Microphone" : [NSNumber numberWithInt:XCUIProtectedResourceMicrophone],
            @"Camera" : [NSNumber numberWithInt:XCUIProtectedResourceCamera],
            @"Library" : [NSNumber numberWithInt:XCUIProtectedResourceMediaLibrary],
            @"HomeKit" : [NSNumber numberWithInt:XCUIProtectedResourceHomeKit],
            @"Bluetooth" : [NSNumber numberWithInt:XCUIProtectedResourceBluetooth],
            @"KeyboardNetwork" : [NSNumber numberWithInt:XCUIProtectedResourceKeyboardNetwork],
            @"Location" : [NSNumber numberWithInt:XCUIProtectedResourceLocation]
        };

        if (@available(iOS 14.0, *)) {
            NSMutableDictionary *protectedResourcesiOS14 = [protectedResources mutableCopy];
            protectedResourcesiOS14[@"Health"] = [NSNumber numberWithInt:XCUIProtectedResourceHealth];
            protectedResources = protectedResourcesiOS14;
        }
    });
}

+ (NSArray <CBXRoute *> *)getRoutes {
    return @[
             [CBXRoute get:endpoint(@"/sessionIdentifier", 1.0) withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {

                 NSUUID *testUUID = [[XCTestConfiguration activeTestConfiguration] sessionIdentifier];
                 NSDictionary *body = @
                 {
                     @"sessionId" : testUUID ? [testUUID UUIDString] : [NSNull null]
                 };

                 [response respondWithJSON:body];
             }],

             [CBXRoute post:endpoint(@"/terminate", 1.0)
                  withBlock:^(RouteRequest *request,
                              NSDictionary *data,
                              RouteResponse *response) {
                      NSString *bundleIdentifier = data[CBX_BUNDLE_ID_KEY];
                      XCUIApplicationState state;
                      state = [Application terminateApplicationWithIdentifier:bundleIdentifier];
                      NSString *stateString;
                      stateString = [XCUIApplication cbxStringForApplicationState:state];
                      [response respondWithJSON:@{@"state" : @(state),
                                                  @"state_string" : stateString}];
                  }
              ],

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
                 application = [[XCUIApplication alloc] initWithBundleIdentifier:identifier];
                 NSString *pid;
                 if (application) {
                     pid = [NSString stringWithFormat:@"%@", @(application.processID)];
                 } else {
                     pid = [NSString stringWithFormat:@"%@", @(-1)];
                 }

                 XCUIApplicationState state = [application state];
                 NSString *stateString;
                 stateString = [XCUIApplication cbxStringForApplicationState:state];

                 NSDictionary *json =
                 @{
                   @"pid" : pid,
                   @"state" : @(state),
                   @"state_string" : stateString
                   };

                 [response respondWithJSON:json];
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

             [CBXRoute post:endpoint(@"/reset-authorization-status-for-resource", 1.0)
                  withBlock:^(RouteRequest *request,
                              NSDictionary *data,
                              RouteResponse *response) {
                 NSString *protectedResourceKey = @"protected_resource";
                 NSString *protectedResourceName = data[protectedResourceKey];

                 if (protectedResourceName == nil) {
                     @throw [CBXException withFormat:
                             @"Missing required key '%@' in request body: %@",
                             protectedResourceKey, data];
                 }

                 NSNumber *protectedResource = protectedResources[protectedResourceName];

                 if (protectedResource == nil) {
                     @throw [CBXException withFormat:
                             @"Unknown protected resource type for key '%@'. Known resources are: %@",
                             protectedResourceName, protectedResources.allKeys];
                 }

                 NSString *bundleIdentifier = data[CBX_BUNDLE_ID_KEY];
                 XCUIApplication *application = [[XCUIApplication alloc]
                                                 initWithBundleIdentifier:bundleIdentifier];

                 [application resetAuthorizationStatusForResource:[protectedResource intValue]];

                 [response respondWithJSON:@{@"result" : @"OK"}];
                }
              ],

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

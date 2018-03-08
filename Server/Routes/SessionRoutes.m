#import "CBXCUITestServer.h"
#import "CBX-XCTest-Umbrella.h"
#import "Application.h"
#import "SessionRoutes.h"
#import "CBXConstants.h"
#import "CBXMacros.h"
#import "CBXRoute.h"

@implementation SessionRoutes

+ (NSArray <CBXRoute *> *)getRoutes {
    return @[
             [CBXRoute post:endpoint(@"/session", 1.0) withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 NSDictionary *json = DATA_TO_JSON(request.body);
                 NSString *bundleId = json[CBX_BUNDLE_ID_KEY] ?: json[@"bundleId"] ?: json[@"bundle_id"];
                 NSArray *launchArgs = json[CBX_LAUNCH_ARGS_KEY] ?: @[];
                 NSDictionary *environment = json[CBX_ENVIRONMENT_KEY] ?: @{};
                 NSNumber *terminateNumber = json[CBX_TERMINATE_AUT_IF_RUNNING_KEY] ?: @(NO);
                 BOOL terminateIfRunning = [terminateNumber boolValue];

                 // Starting in Xcode 9, we can no longer check if the
                 // if the AUT is installed using the LSApplication* private
                 // methods or an XCUIApplication#exists query.

                 [Application launchAppWithBundleId:bundleId
                                         launchArgs:launchArgs
                                          launchEnv:environment
                                 terminateIfRunning:terminateIfRunning];

                 [response respondWithJSON:@{@"status" : @"launched!"}];
             }],

             [CBXRoute delete:endpoint(@"/session", 1.0)
                    withBlock:^(RouteRequest *request,
                                NSDictionary *data,
                                RouteResponse *response) {

                        XCUIApplicationState state;
                        state = [Application terminateCurrentApplication];

                        [response respondWithJSON:@{@"state" : @(state)}];
                    }],

             [CBXRoute post:endpoint(@"/shutdown", 1.0) withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 //Want to make sure this route actually returns a response to the client before shutting down
                 NSDictionary *json = @{
                                        @"message" : @"Goodbye.",
                                        @"delay" : @(CBX_SERVER_SHUTDOWN_DELAY)
                                        };
                 [response respondWithJSON:json];
                 [CBXCUITestServer stop];
             }]
             ];
}

@end

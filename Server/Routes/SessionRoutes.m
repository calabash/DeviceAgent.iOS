//
//  SessionRoutes.m
//  xcuitest-server
//

#import "CBShutdownServerException.h"
#import "CBXCUITestServer.h"
#import "CBApplication.h"
#import "SessionRoutes.h"
#import "Testmanagerd.h"
#import "CBConstants.h"
#import "XCDeviceEvent.h"
#import "CBMacros.h"

@implementation SessionRoutes

+ (NSArray <CBRoute *> *)getRoutes {
    return @[
             [CBRoute post:endpoint(@"/session", 1.0) withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 NSDictionary *json = DATA_TO_JSON(request.body);
                 NSString *bundlePath = json[CB_BUNDLE_PATH_KEY];
                 NSString *bundleID = json[CB_BUNDLE_ID_KEY] ?: json[@"bundleId"] ?: json[@"bundle_id"];
                 NSArray *launchArgs = json[CB_LAUNCH_ARGS_KEY] ?: @[];
                 NSDictionary *environment = json[CB_ENVIRONMENT_KEY] ?: @{};
                 
                 NSAssert(bundleID, @"Must specify \"bundleID\"");
                 
                 if (!bundlePath || [bundlePath isEqual:[NSNull null]]) {
                     bundlePath = nil;
                 }
                 [CBApplication launchBundlePath:bundlePath
                                        bundleID:bundleID
                                      launchArgs:launchArgs
                                             env:environment];
                 
                 [response respondWithJSON:@{@"status" : @"launched!"}];
             }],
             
             [CBRoute delete:endpoint(@"/session", 1.0) withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 [CBApplication killCurrentApplication];
                 [response respondWithJSON:@{@"status" : @"dead"}];
             }],
             
             [CBRoute post:endpoint(@"/shutdown", 1.0) withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 //Want to make sure this route actually returns a response to the client before shutting down
                 [response respondWithJSON:@{@"message" : @"Goodbye."}];
                 [CBXCUITestServer stop];
             }]
             
             ];
}

@end

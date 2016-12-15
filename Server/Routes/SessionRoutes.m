#import "CBXCUITestServer.h"
#import "Application.h"
#import "SessionRoutes.h"
#import "CBXConstants.h"
#import "CBXMacros.h"
#import "CBLSApplicationWorkspace.h"
#import "CBXException.h"

@implementation SessionRoutes

+ (NSArray <CBXRoute *> *)getRoutes {
    return @[
             [CBXRoute post:endpoint(@"/session", 1.0) withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 NSDictionary *json = DATA_TO_JSON(request.body);
                 NSString *bundlePath = json[CBX_BUNDLE_PATH_KEY];
                 NSString *bundleID = json[CBX_BUNDLE_ID_KEY] ?: json[@"bundleId"] ?: json[@"bundle_id"];
                 NSArray *launchArgs = json[CBX_LAUNCH_ARGS_KEY] ?: @[];
                 NSDictionary *environment = json[CBX_ENVIRONMENT_KEY] ?: @{};
                 
                 NSAssert(bundleID, @"Must specify \"bundleID\"");
                 
                 if (!bundlePath || [bundlePath isEqual:[NSNull null]]) {
                     bundlePath = nil;
                     if (![CBLSApplicationWorkspace applicationIsInstalled:bundleID]) {
                         NSString *errorMsg;
                         errorMsg = [NSString stringWithFormat:@"Application with identifier: %@ is not installed.",
                                                               bundleID];
                         @throw [CBXException withMessage:errorMsg userInfo:nil];
                     }
                 } else {
                     // Passing bundle paths is not supported yet.
                 }
                 [Application launchBundlePath:bundlePath
                                        bundleID:bundleID
                                      launchArgs:launchArgs
                                             env:environment];
                 
                 [response respondWithJSON:@{@"status" : @"launched!"}];
             }],
             
             [CBXRoute delete:endpoint(@"/session", 1.0) withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 [Application killCurrentApplication];
                 [response respondWithJSON:@{@"status" : @"dead"}];
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

//
//  SessionRoutes.m
//  xcuitest-server
//

#import "CBApplication.h"
#import "SessionRoutes.h"
#import "CBConstants.h"
#import "JSONUtils.h"

@implementation SessionRoutes
+ (NSArray <CBRoute *> *)getRoutes {
    return @[
             [CBRoute post:@"/session" withBlock:^(RouteRequest *request, RouteResponse *response) {
                 NSDictionary *json = [JSONUtils dataToJSON:request.body];
                 NSString *bundlePath = json[CB_BUNDLE_PATH_KEY];
                 NSString *bundleID = json[CB_BUNDLE_ID_KEY];
                 NSArray *launchArgs = json[CB_LAUNCH_ARGS_KEY] ?: @[];
                 NSDictionary *environment = json[CB_ENVIRONMENT_KEY] ?: @{};
                 
                 NSAssert(bundleID, @"Must specify \"bundleID\"");
                 
                 if (!bundlePath || [bundlePath isEqual:[NSNull null]]) {
                     [CBApplication launchBundleID:bundleID
                                        launchArgs:launchArgs
                                               env:environment];
                 } else {
                     [CBApplication launchBundlePath:bundlePath
                                            bundleID:bundleID
                                          launchArgs:launchArgs
                                                 env:environment];
                 }
                 [response respondWithJSON:@{@"status" : @"launching!"}];
             }]
             ];
}
@end

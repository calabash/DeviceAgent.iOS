//
//  SessionRoutes.m
//  xcuitest-server
//

#import "CBShutdownServerException.h"
#import "CBXCUITestServer.h"
#import "CBApplication.h"
#import "SessionRoutes.h"
#import "CBConstants.h"
#import "CBMacros.h"

@implementation SessionRoutes
+ (NSArray <CBRoute *> *)getRoutes {
    return @[
             [CBRoute post:@"/session" withBlock:^(RouteRequest *request, RouteResponse *response) {
                 NSDictionary *json = DATA_TO_JSON(request.body);
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
             }],
             
             [CBRoute post:@"/shutdown" withBlock:^(RouteRequest *request, RouteResponse *response) {
                 //Want to make sure this route actually returns a response to the client before shutting down
                 [response respondWithString:@"Goodbye."];
                 
                 //TODO: can we do this in a response completion callback rather than dispatch_after?
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                     CBShutdownServerException *up = [[CBShutdownServerException alloc] initWithName:@"Shutdown"
                                                                                              reason:@"User terminated server"
                                                                                            userInfo:nil];
                     @throw up;
                 });
             }]
             ];
}
@end

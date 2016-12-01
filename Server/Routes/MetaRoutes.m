
#import "MetaRoutes.h"
#import "XCTestDriver.h"
#import "Application.h"
#import "CBXMacros.h"
#import "CBXDevice.h"
#import "CBXInfoPlist.h"

@implementation MetaRoutes
+ (NSArray <CBXRoute *> *)getRoutes {
    return @[
             [CBXRoute get:endpoint(@"/sessionIdentifier", 1.0) withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 NSUUID *testUUID = [XCTestDriver sharedTestDriver].sessionIdentifier;
                 [response respondWithJSON:@{@"sessionId" : [testUUID UUIDString]}];
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

             [CBXRoute get:endpoint(@"/environment", 1.0) withBlock:^(RouteRequest *request,
                                                                      NSDictionary *data,
                                                                      RouteResponse *response) {
                 NSDictionary *aut_environment = @{};
                 if ([Application currentApplication]) {
                     aut_environment = [[Application currentApplication] launchEnvironment];
                 }

                 NSDictionary *device_agent_environment;
                 device_agent_environment = [[NSProcessInfo processInfo] environment];

                 NSDictionary *json;
                 json = @{
                          @"aut_environment" : aut_environment,
                          @"device_agent_environment" : device_agent_environment };

                 [response respondWithJSON:json];
             }]
             ];
}
@end

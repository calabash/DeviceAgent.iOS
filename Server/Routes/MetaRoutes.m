
#import "MetaRoutes.h"
#import "XCTestDriver.h"
#import "Application.h"
#import "CBXMacros.h"
#import "CBXDevice.h"

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
             }]
             ];
}
@end

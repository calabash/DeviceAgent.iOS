
#import "MetaRoutes.h"
#import "XCTestDriver.h"
#import "Application.h"

@implementation MetaRoutes
+ (NSArray <CBXRoute *> *)getRoutes {
    return @[
             [CBXRoute get:@"/sessionIdentifier" withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 NSUUID *testUUID = [XCTestDriver sharedTestDriver].sessionIdentifier;
                 [response respondWithJSON:@{@"sessionId" : [testUUID UUIDString]}];
             }],
             [CBXRoute get:@"/pid" withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 NSString *pidString = [NSString stringWithFormat:@"%d",
                                        [Application currentApplication].processID];
                 [response respondWithJSON:@{@"pid" : pidString}];
             }]
             ];
}
@end

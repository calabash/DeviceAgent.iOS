//
//  GestureRotues.m
//  xcuitest-server
//

#import "CBApplication+Gestures.h"
#import "GestureRotues.h"
#import "CBConstants.h"
#import "CBMacros.h"

@implementation GestureRotues
+ (NSArray<CBRoute *> *)getRoutes {
    return @[
             [CBRoute post:@"/tap/coordinates" withBlock:^(RouteRequest *request, RouteResponse *response) {
                 NSDictionary *arguments = DATA_TO_JSON(request.body);
                 float x = [arguments[CB_X_KEY] floatValue],
                    y = [arguments[CB_Y_KEY] floatValue];
                 [CBApplication tap:x :y];
                 [response respondWithString:@"OK"];
             }]
             ];
}
@end

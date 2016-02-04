//
//  GestureRotues.m
//  xcuitest-server
//

#import "CBApplication+Gestures.h"
#import "GestureRoutes.h"
#import "CBConstants.h"
#import "CBMacros.h"

@implementation GestureRoutes
+ (NSArray<CBRoute *> *)getRoutes {
    return @[
             /*
              *     Coordinates API
              */
             [CBRoute post:@"/tap/coordinates" withBlock:^(RouteRequest *request, RouteResponse *response) {
                 NSDictionary *arguments = DATA_TO_JSON(request.body);
                 float x = [arguments[CB_X_KEY] floatValue],
                    y = [arguments[CB_Y_KEY] floatValue];
                 
                 [CBApplication tap:x :y];
                 [response respondWithString:@"OK"];
             }],
             
             [CBRoute post:@"/doubleTap/coordinates" withBlock:^(RouteRequest *request, RouteResponse *response) {
                 NSDictionary *arguments = DATA_TO_JSON(request.body);
                 float x = [arguments[CB_X_KEY] floatValue],
                    y = [arguments[CB_Y_KEY] floatValue];
                 
                 [CBApplication doubleTap:x :y];
                 [response respondWithString:@"OK"];
             }],
             
             [CBRoute post:@"/pressForDuration/coordinates" withBlock:^(RouteRequest *request, RouteResponse *response) {
                 NSDictionary *arguments = DATA_TO_JSON(request.body);
                 float x = [arguments[CB_X_KEY] floatValue],
                    y = [arguments[CB_Y_KEY] floatValue],
                 duration = [arguments[CB_DURATION_KEY] floatValue];
                 
                 [CBApplication press:x :y forDuration:duration];
                 [response respondWithString:@"OK"];
             }],
             
             [CBRoute post:@"/pressForDuration/coordinates/thenDragTo" withBlock:^(RouteRequest *request, RouteResponse *response) {
                 NSDictionary *arguments = DATA_TO_JSON(request.body);
                 float x1 = [arguments[CB_X1_KEY] floatValue],
                    y1 = [arguments[CB_Y1_KEY] floatValue],
                    duration = [arguments[CB_DURATION_KEY] floatValue],
                    x2 = [arguments[CB_X2_KEY] floatValue],
                    y2 = [arguments[CB_Y2_KEY] floatValue];
                 
                 [CBApplication press:x1 :y1 forDuration:duration thenDragTo:x2 :y2];
                 [response respondWithString:@"OK"];
             }],
             
             /*
              *     Marked API
              */
             
             //TODO
             
             ];
}

/* TODO
- (void)tap;
- (void)doubleTap;
- (void)twoFingerTap;
- (void)tapWithNumberOfTaps:(NSUInteger)numberOfTaps numberOfTouches:(NSUInteger)numberOfTouches;
- (void)pressForDuration:(NSTimeInterval)duration;
- (void)pressForDuration:(NSTimeInterval)duration thenDragToElement:(XCUIElement *)otherElement;
- (void)swipeUp;
- (void)swipeDown;
- (void)swipeLeft;
- (void)swipeRight;
- (void)pinchWithScale:(CGFloat)scale velocity:(CGFloat)velocity;
- (void)rotate:(CGFloat)rotation withVelocity:(CGFloat)velocity;
- (void)typeText:(NSString *)text;
 */
@end

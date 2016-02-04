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

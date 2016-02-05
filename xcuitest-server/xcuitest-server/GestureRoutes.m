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
             
             [CBRoute post:@"/tap/marked/:text"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                 NSString *text = request.params[CB_TEXT_KEY];
                     
                 response.statusCode = [CBApplication tapMarked:text] ?
                    HTTP_STATUS_CODE_EVERYTHING_OK :
                    HTTP_STATUS_CODE_INVALID_REQUEST;
                 [response respondWithString:CB_EMPTY_STRING];
             }],
             
             [CBRoute post:@"/doubleTap/marked/:text"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                 NSString *text = request.params[CB_TEXT_KEY];
                 
                 response.statusCode = [CBApplication doubleTapMarked:text] ?
                 HTTP_STATUS_CODE_EVERYTHING_OK :
                 HTTP_STATUS_CODE_INVALID_REQUEST;
                 [response respondWithString:CB_EMPTY_STRING];
             }],
             
             [CBRoute post:@"/twoFingerTap/marked/:text"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                     NSString *text = request.params[CB_TEXT_KEY];
                     
                     response.statusCode = [CBApplication twoFingerTapMarked:text] ?
                     HTTP_STATUS_CODE_EVERYTHING_OK :
                     HTTP_STATUS_CODE_INVALID_REQUEST;
                     [response respondWithString:CB_EMPTY_STRING];
                 }],
             
             [CBRoute post:@"/swipe/:direction/marked/:text"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                     NSString *direction = [request.params[CB_DIRECTION_KEY] lowercaseString];
                     NSString *text = request.params[CB_TEXT_KEY];
                     
                     //TODO: What should the default message be?
                     BOOL success = NO;
                     NSString *message = CB_EMPTY_STRING;
                     if ([direction isEqualToString:CB_UP_KEY]) {
                         success = [CBApplication swipeUpOnMarked:text];
                     } else if ([direction isEqualToString:CB_DOWN_KEY]) {
                         success = [CBApplication swipeDownOnMarked:text];
                     } else if ([direction isEqualToString:CB_LEFT_KEY]) {
                         success = [CBApplication swipeLeftOnMarked:text];
                     } else if ([direction isEqualToString:CB_RIGHT_KEY]) {
                         success = [CBApplication swipeRightOnMarked:text];
                     } else {
                         message = [NSString stringWithFormat:@"'%@' is not a valid direction", direction];
                     }
                     response.statusCode = success ?
                        HTTP_STATUS_CODE_EVERYTHING_OK :
                        HTTP_STATUS_CODE_INVALID_REQUEST;
                     [response respondWithString:message];
                 }],
             ];
}

/* TODO
- (void)pinchWithScale:(CGFloat)scale velocity:(CGFloat)velocity;
- (void)rotate:(CGFloat)rotation withVelocity:(CGFloat)velocity;
- (void)typeText:(NSString *)text;
 - (void)tapWithNumberOfTaps:(NSUInteger)numberOfTaps numberOfTouches:(NSUInteger)numberOfTouches;
 - (void)pressForDuration:(NSTimeInterval)duration;
 - (void)pressForDuration:(NSTimeInterval)duration thenDragToElement:(XCUIElement *)otherElement;
 */
@end

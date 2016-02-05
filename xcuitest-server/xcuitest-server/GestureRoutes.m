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
#pragma mark - Coordinate Routes
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
#pragma mark - Marked Routes
             
             [CBRoute post:@"/tap/marked/:text"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                     [self handleRequest:request
                                response:response
                        forMarkedGesture:@selector(tapMarked:)];
             }],
             
             [CBRoute post:@"/doubleTap/marked/:text"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                     [self handleRequest:request
                                response:response
                        forMarkedGesture:@selector(doubleTapMarked:)];
             }],
             
             [CBRoute post:@"/twoFingerTap/marked/:text"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                     [self handleRequest:request
                                response:response
                        forMarkedGesture:@selector(twoFingerTapMarked:)];
                 }],
             
             [CBRoute post:@"/swipe/:direction/marked/:text"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                     NSString *direction = [request.params[CB_DIRECTION_KEY] lowercaseString];
                    
                     SEL gesture = nil;
                     if ([direction isEqualToString:CB_UP_KEY]) {
                         gesture = @selector(swipeUpOnMarked:);
                     } else if ([direction isEqualToString:CB_DOWN_KEY]) {
                         gesture = @selector(swipeDownOnMarked:);
                     } else if ([direction isEqualToString:CB_LEFT_KEY]) {
                         gesture = @selector(swipeLeftOnMarked:);
                     } else if ([direction isEqualToString:CB_RIGHT_KEY]) {
                         gesture = @selector(swipeRightOnMarked:);
                     } else {
                         response.statusCode = HTTP_STATUS_CODE_INVALID_REQUEST;
                         [response respondWithString:[NSString stringWithFormat:@"'%@' is not a valid direction", direction]];
                         return;
                     }
                     
                     [self handleRequest:request
                                response:response
                        forMarkedGesture:gesture];
                 }],
             
             /*
              *     Identifier API
              */
#pragma mark - Identifier Routes
             
             [CBRoute post:@"/tap/id/:id"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                     [self handleRequest:request
                                response:response
                    forIdentifierGesture:@selector(tapIdentifier:)];
                 }],
             
             [CBRoute post:@"/doubleTap/id/:id"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                     [self handleRequest:request
                                response:response
                    forIdentifierGesture:@selector(doubleTapIdentifier:)];
                 }],
             
             [CBRoute post:@"/twoFingerTap/id/:id"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                     [self handleRequest:request
                                response:response
                    forIdentifierGesture:@selector(twoFingerTapIdentifier:)];
                 }],
             
             [CBRoute post:@"/swipe/:direction/id/:id"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                     NSString *direction = [request.params[CB_DIRECTION_KEY] lowercaseString];
                     
                     SEL gesture = nil;
                     if ([direction isEqualToString:CB_UP_KEY]) {
                         gesture = @selector(swipeUpOnIdentifier:);
                     } else if ([direction isEqualToString:CB_DOWN_KEY]) {
                         gesture = @selector(swipeDownOnIdentifier:);
                     } else if ([direction isEqualToString:CB_LEFT_KEY]) {
                         gesture = @selector(swipeLeftOnIdentifier:);
                     } else if ([direction isEqualToString:CB_RIGHT_KEY]) {
                         gesture = @selector(swipeRightOnIdentifier:);
                     } else {
                         response.statusCode = HTTP_STATUS_CODE_INVALID_REQUEST;
                         [response respondWithString:[NSString stringWithFormat:@"'%@' is not a valid direction", direction]];
                         return;
                     }
                     
                     [self handleRequest:request
                                response:response
                    forIdentifierGesture:gesture];
                 }],
             ];
}

+ (void)handleRequest:(RouteRequest *)request
             response:(RouteResponse *)response
     forMarkedGesture:(SEL)gesture {
    [self handleRequest:request
               response:response
             forGesture:gesture
            propertyKey:CB_TEXT_KEY];
}

+ (void)handleRequest:(RouteRequest *)request
             response:(RouteResponse *)response
 forIdentifierGesture:(SEL)gesture {
    [self handleRequest:request
               response:response
             forGesture:gesture
            propertyKey:CB_IDENTIFIER_KEY];
}

+ (void)handleRequest:(RouteRequest *)request
             response:(RouteResponse *)response
           forGesture:(SEL)gesture
          propertyKey:(NSString *)propertyKey {
    NSString *toMatch = request.params[propertyKey];
    BOOL success = [[CBApplication performSelector:gesture withObject:toMatch] boolValue];
    response.statusCode = success ?
    HTTP_STATUS_CODE_EVERYTHING_OK :
    HTTP_STATUS_CODE_INVALID_REQUEST;
    [response respondWithString:CB_EMPTY_STRING];
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

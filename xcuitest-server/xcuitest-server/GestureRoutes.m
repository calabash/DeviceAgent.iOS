//
//  GestureRotues.m
//  xcuitest-server
//

#import "CBApplication+Gestures.h"
#import "GestureRoutes.h"
#import "CBConstants.h"
#import "JSONUtils.h"
#import "CBMacros.h"

@implementation GestureRoutes
+ (NSArray<CBRoute *> *)getRoutes {
    return @[
             
#pragma mark - Non-specific Routes
             [CBRoute post:@"/swipe/:direction"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                     NSString *direction = [request.params[CB_DIRECTION_KEY] lowercaseString];
                     
                     SEL gesture = nil;
                     if ([direction isEqualToString:CB_UP_KEY]) {
                         gesture = @selector(swipeUp);
                     } else if ([direction isEqualToString:CB_DOWN_KEY]) {
                         gesture = @selector(swipeDown);
                     } else if ([direction isEqualToString:CB_LEFT_KEY]) {
                         gesture = @selector(swipeLeft);
                     } else if ([direction isEqualToString:CB_RIGHT_KEY]) {
                         gesture = @selector(swipeRight);
                     } else {
                         response.statusCode = HTTP_STATUS_CODE_INVALID_REQUEST;
                         [response respondWithString:[NSString stringWithFormat:@"'%@' is not a valid direction", direction]];
                         return;
                     }
                    
                     [CBApplication performSelector:gesture withObject:nil];
                     [response respondWithString:@"Success"];
                 }],
             
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
             
             [CBRoute post:@"/pinchWithScaleAndVelocity/marked/:text"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                     NSDictionary *args = DATA_TO_JSON(request.body);
                     CGFloat scale = [args[CB_SCALE_KEY] floatValue];
                     CGFloat velocity = [args[CB_VELOCITY_KEY] floatValue];
                     NSString *mark = request.params[CB_TEXT_KEY];
                     XCUIElement *el = [CBApplication pinchWithScale:scale velocity:velocity marked:mark];
                     [response respondWithJSON:[JSONUtils elementToJSON:el]];
                 }],
             
             [CBRoute post:@"/rotateWithVelocity/marked/:text"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                     NSDictionary *args = DATA_TO_JSON(request.body);
                     CGFloat degrees = [args[CB_ROTATION_KEY] floatValue];
                     CGFloat velocity = [args[CB_VELOCITY_KEY] floatValue];
                     NSString *mark = request.params[CB_TEXT_KEY];
                     XCUIElement *el = [CBApplication rotateDegrees:degrees velocity:velocity marked:mark];
                     [response respondWithJSON:[JSONUtils elementToJSON:el]];
                 }],
             
             [CBRoute post:@"/typeText/marked/:text"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                     NSDictionary *args = DATA_TO_JSON(request.body);
                     NSString *mark = request.params[CB_TEXT_KEY];
                     NSString *text = args[CB_TEXT_KEY];
                     
                     XCUIElement *el = [CBApplication typeText:text marked:mark];
                     [response respondWithJSON:[JSONUtils elementToJSON:el]];
                 }],
             
             [CBRoute post:@"/tapWithNumberOfTapsAndTouches/marked/:text"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                     NSDictionary *args = DATA_TO_JSON(request.body);
                     NSString *mark = request.params[CB_TEXT_KEY];
                     NSUInteger numTaps = [args[CB_NUM_TAPS_KEY] unsignedIntegerValue];
                     NSUInteger numTouches = [args[CB_NUM_TOUCHES_KEY] unsignedIntegerValue];
                     
                     XCUIElement *el = [CBApplication tapWithNumberOfTaps:numTaps
                                                       numberOfTouches:numTouches
                                                                marked:mark];
                     [response respondWithJSON:[JSONUtils elementToJSON:el]];
                 }],
             
             [CBRoute post:@"/pressForDuration/marked/:text"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                     NSDictionary *args = DATA_TO_JSON(request.body);
                     NSString *mark = request.params[CB_TEXT_KEY];
                     CGFloat duration = [args[CB_DURATION_KEY] floatValue];
                     
                     XCUIElement *el = [CBApplication pressForDuration:duration
                                                             marked:mark];
                     [response respondWithJSON:[JSONUtils elementToJSON:el]];
                 }],
             
             [CBRoute post:@"/pressForDuration/marked/:text1/thenDragToElement/marked/:text2"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                     NSDictionary *args = DATA_TO_JSON(request.body);
                     NSString *mark1 = request.params[CB_TEXT1_KEY];
                     NSString *mark2 = request.params[CB_TEXT2_KEY];
                     CGFloat duration = [args[CB_DURATION_KEY] floatValue];
                     
                     XCUIElement *el = [CBApplication pressMarked:mark1
                                                   forDuration:duration
                                       thenDragToElementMarked:mark2];
                     [response respondWithJSON:[JSONUtils elementToJSON:el]];
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
             
             [CBRoute post:@"/pinchWithScaleAndVelocity/id/:id"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                     NSDictionary *args = DATA_TO_JSON(request.body);
                     CGFloat scale = [args[CB_SCALE_KEY] floatValue];
                     CGFloat velocity = [args[CB_VELOCITY_KEY] floatValue];
                     NSString *identifier = request.params[CB_IDENTIFIER_KEY];
                     XCUIElement *el = [CBApplication pinchWithScale:scale velocity:velocity identifier:identifier];
                     [response respondWithJSON:[JSONUtils elementToJSON:el]];
             }],
             
             [CBRoute post:@"/rotateWithVelocity/id/:id"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                     NSDictionary *args = DATA_TO_JSON(request.body);
                     CGFloat degrees = [args[CB_ROTATION_KEY] floatValue];
                     CGFloat velocity = [args[CB_VELOCITY_KEY] floatValue];
                     NSString *identifier = request.params[CB_IDENTIFIER_KEY];
                     XCUIElement *el = [CBApplication rotateDegrees:degrees velocity:velocity identifier:identifier];
                     [response respondWithJSON:[JSONUtils elementToJSON:el]];
                 }],
             
             [CBRoute post:@"/typeText/id/:id"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                     NSDictionary *args = DATA_TO_JSON(request.body);
                     NSString *identifier = request.params[CB_IDENTIFIER_KEY];
                     NSString *text = args[CB_TEXT_KEY];
                     
                     XCUIElement *el = [CBApplication typeText:text identifier:identifier];
                     [response respondWithJSON:[JSONUtils elementToJSON:el]];
                 }],
             
             [CBRoute post:@"/tapWithNumberOfTapsAndTouches/id/:id"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                     NSDictionary *args = DATA_TO_JSON(request.body);
                     NSString *identifier = request.params[CB_IDENTIFIER_KEY];
                     NSUInteger numTaps = [args[CB_NUM_TAPS_KEY] unsignedIntegerValue];
                     NSUInteger numTouches = [args[CB_NUM_TOUCHES_KEY] unsignedIntegerValue];
                     
                     XCUIElement *el = [CBApplication tapWithNumberOfTaps:numTaps
                                                       numberOfTouches:numTouches
                                                            identifier:identifier];
                     [response respondWithJSON:[JSONUtils elementToJSON:el]];
                 }],
             
             [CBRoute post:@"/pressForDuration/id/:id"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                     NSDictionary *args = DATA_TO_JSON(request.body);
                     NSString *identifier = request.params[CB_IDENTIFIER_KEY];
                     CGFloat duration = [args[CB_DURATION_KEY] floatValue];
                     
                     XCUIElement *el = [CBApplication pressForDuration:duration
                                                         identifier:identifier];
                     [response respondWithJSON:[JSONUtils elementToJSON:el]];
                 }],
             
             [CBRoute post:@"/pressForDuration/id/:id1/thenDragToElement/id/:id2"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                     NSDictionary *args = DATA_TO_JSON(request.body);
                     NSString *id1 = request.params[CB_IDENTIFIER1_KEY];
                     NSString *id2 = request.params[CB_IDENTIFIER2_KEY];
                     CGFloat duration = [args[CB_DURATION_KEY] floatValue];
                     
                     XCUIElement *el = [CBApplication pressIdentifier:id1
                                                          forDuration:duration
                                      thenDragToElementWithIdentifier:id2];
                     [response respondWithJSON:[JSONUtils elementToJSON:el]];
                 }],
             
#pragma mark - TestID Routes
             [CBRoute post:@"/tap/test_id/:test_id"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                     NSNumber *test_id = @([request.params[CB_TEST_ID] integerValue]);
                     XCUIElement *el = [CBApplication cachedElementOrThrow:test_id];
                     [el tap];
                     [response respondWithJSON:[JSONUtils elementToJSON:el]];
                 }],
             
             [CBRoute post:@"/typeText/test_id/:test_id"
                 withBlock:^(RouteRequest *request, RouteResponse *response) {
                     NSDictionary *args = DATA_TO_JSON(request.body);
                     NSString *text = args[CB_TEXT_KEY];
                     NSNumber *test_id = @([request.params[CB_TEST_ID] integerValue]);
                     XCUIElement *el = [CBApplication cachedElementOrThrow:test_id];
                     [el typeText:text];
                     [response respondWithString:@"OK"];
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
    XCUIElement *el = [CBApplication performSelector:gesture withObject:toMatch];
    [response respondWithJSON:[JSONUtils elementToJSON:el]];
}


@end

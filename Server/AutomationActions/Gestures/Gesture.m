
#import "CoordinateQuery.h"
#import "ThreadUtils.h"
#import "Gesture.h"

@implementation Gesture

+ (NSString *)name {
    _must_override_exception;
}

+ (NSArray <NSString *> *)optionalKeys { return @[ CBX_DURATION_KEY ]; }
+ (NSArray <NSString *> *)requiredKeys { return @[]; }

+ (JSONKeyValidator *)validator {
    return [JSONKeyValidator withRequiredKeys:[self requiredKeys]
                                 optionalKeys:[self optionalKeys]];
}

+ (Gesture *)executeWithGestureConfiguration:(GestureConfiguration *)gestureConfig
                                         query:(Query *)query
                                    completion:(CompletionBlock)completion {
    Gesture *gest = [self withGestureConfiguration:gestureConfig
                                             query:query];
    [gest execute:completion];
    return gest;
}

+ (instancetype)withGestureConfiguration:(GestureConfiguration *)gestureConfig
                                   query:(Query *)query {
    Gesture *gesture = [self new];
    
    gesture.gestureConfiguration = gestureConfig;
    gesture.query = query;
    
    return gesture;
}

- (XCSynthesizedEventRecord *)eventWithCoordinates:(NSArray<Coordinate *> *)coordinates {
    _must_override_exception;
}

- (XCTouchGesture *)gestureWithCoordinates:(NSArray<Coordinate *> *)coordinates {
    _must_override_exception;
}

- (CBXTouchEvent *)cbxEventWithCoordinates:(NSArray<Coordinate *> *)coordinates {
    _must_override_exception;
}

- (void)validate {
    //TODO:
    //Just assume it's valid by default?
}

- (void)execute:(CompletionBlock)completion {
    [self validate];
    
    NSMutableArray <Coordinate *> *coords = [NSMutableArray new];
    if (self.query.isCoordinateQuery) {
        CoordinateQuery *cq = (CoordinateQuery *)self.query;
        if (cq.coordinate) {
            [coords addObject:cq.coordinate];
        }
        if (cq.coordinates) {
            [coords addObjectsFromArray:cq.coordinates];
        }
    } else {
        NSArray <XCUIElement *> *elements = [self.query execute];
        if (elements.count == 0) {
            @throw [CBXException withMessage:@"Error performing gesture: No elements match query."];
        }
        for (XCUIElement *el in elements) {
            /*
                TODO: discussion of 'visibility'
            */
            CGRect frame = el.wdFrame;
            CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
            [coords addObject:[Coordinate fromRaw:center]];
        }
    }
    
    
    //Testmanagerd calls are async, but the http server is sync so we need to synchronize it.
    [ThreadUtils runSync:^(BOOL *setToTrueWhenDone, NSError *__autoreleasing *err) {
        // This is temporary try/catch block until all the Gestures are converted
        // to the new CBXTouchEvent interface.
        @try {
            CBXTouchEvent *event = [self cbxEventWithCoordinates:coords];
            if ([[XCTestDriver sharedTestDriver] daemonProtocolVersion] != 0x0) {
                [[Testmanagerd get] _XCT_synthesizeEvent:event.event
                                              completion:^(NSError *e) {
                                                  *err = e;
                                                  *setToTrueWhenDone = YES;
                                              }];
            } else {
                [[Testmanagerd get] _XCT_performTouchGesture:event.gesture
                                                  completion:^(NSError *e) {
                                                      *err = e;
                                                      *setToTrueWhenDone = YES;
                                                  }];
            }
        } @catch (CBXException *e) {
            NSLog(@"cbxEventForCoordinates is NYI, falling back to previous interface");
            if ([[XCTestDriver sharedTestDriver] daemonProtocolVersion] != 0x0) {
                [[Testmanagerd get] _XCT_synthesizeEvent:[self eventWithCoordinates:coords]
                                              completion:^(NSError *e) {
                                                  *err = e;
                                                  *setToTrueWhenDone = YES;
                                              }];
            } else {
                [[Testmanagerd get] _XCT_performTouchGesture:[self gestureWithCoordinates:coords]
                                                  completion:^(NSError *e) {
                                                      *err = e;
                                                      *setToTrueWhenDone = YES;
                                                  }];
            }
        }
    } completion:completion];
}

@end

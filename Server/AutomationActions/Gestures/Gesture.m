
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
    __block NSError *err;
    [ThreadUtils runSync:^(BOOL *setToTrueWhenDone) {

        if ([[XCTestDriver sharedTestDriver] daemonProtocolVersion] ) {
            NSLog(@"WARNING: Testing on daemonProtocolVersion %@", @([[XCTestDriver sharedTestDriver] daemonProtocolVersion]));
        }
        CBXTouchEvent *event = [self cbxEventWithCoordinates:coords];
        [[Testmanagerd get] _XCT_synthesizeEvent:event.event
                                      completion:^(NSError *e) {
                                          err = e;
                                          *setToTrueWhenDone = YES;
                                      }];
    }];
    completion(err);
}

@end

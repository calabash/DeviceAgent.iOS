
#import "CoordinateQuery.h"
#import "Gesture.h"

@implementation Gesture

+ (NSString *)name {
    _must_override_exception;
}

+ (NSArray <NSString *> *)optionalKeys { return @[ CB_DURATION_KEY ]; }
+ (NSArray <NSString *> *)requiredKeys { return @[]; }

+ (JSONKeyValidator *)validator {
    return [JSONKeyValidator withRequiredKeys:[self requiredKeys]
                                 optionalKeys:[self optionalKeys]];
}

+ (NSArray <NSString *> *)defaultOptionalSpecifiers {
    return @[CB_IDENTIFIER_KEY,
             CB_TEXT_KEY,
             CB_TEXT_LIKE_KEY,
             CB_PROPERTY_KEY,
             CB_PROPERTY_LIKE_KEY,
             CB_INDEX_KEY];
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

- (void)validate {
    //TODO:
    //Just assume it's valid by default?
}

- (void)execute:(CompletionBlock)completion {
    [self validate];
    
    NSMutableArray <Coordinate *> *coords = [NSMutableArray new];
    if (self.query.isCoordinateQuery) {
        CoordinateQuery *cq = [self.query asCoordinateQuery];
        if (cq.coordinate) {
            [coords addObject:cq.coordinate];
        }
        if (cq.coordinates) {
            [coords addObjectsFromArray:cq.coordinates];
        }
    } else {
        NSArray <XCUIElement *> *elements = [self.query execute];
        if (elements.count == 0) {
            @throw [CBException withMessage:@"Error performing gesture: No elements match query."];
        }
        for (XCUIElement *el in elements) {
            /*
                TODO: discussion of 'visibility'
            */
            CGRect frame = el.wdFrame;
            CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidX(frame));
            [coords addObject:[Coordinate fromRaw:center]];
        }
    }
    
    //Testmanagerd calls are async, but the http server is sync so we need to synchronize it.
    __block BOOL done = NO;
    __block NSError *err;
    
    if ([[XCTestDriver sharedTestDriver] daemonProtocolVersion] != 0x0) {
        [[Testmanagerd get] _XCT_synthesizeEvent:[self eventWithCoordinates:coords]
                                      completion:^(NSError *e) {
            done = YES;
            err = e;
        }];
    } else {
        [[Testmanagerd get] _XCT_performTouchGesture:[self gestureWithCoordinates:coords]
                                          completion:^(NSError *e) {
            done = YES;
            err = e;
        }];
    }

    while(!done){
        //TODO: fine-tune this. 
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:CB_RUNLOOP_INTERVAL]];
    }
    if (err) @throw [CBException withMessage:@"Error performing gesture"];
    completion(err);
}

@end


#import "CoordinateQuery.h"
#import "ThreadUtils.h"
#import "Gesture.h"
#import "XCUIElement+WebDriverAttributes.h"
#import "Testmanagerd.h"
#import "CBXTouchEvent.h"
#import "CBXException.h"
#import "JSONKeyValidator.h"
#import "Coordinate.h"
#import "CBXConstants.h"

@implementation Gesture

+ (NSString *)name {
    @throw [CBXException overrideMethodInSubclassExceptionWithClass:self.class
                                                           selector:_cmd];
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
    @throw [CBXException overrideMethodInSubclassExceptionWithClass:self.class
                                                           selector:_cmd];

}

- (CBXTouchEvent *)cbxEventWithCoordinates:(NSArray<Coordinate *> *)coordinates {
    @throw [CBXException overrideMethodInSubclassExceptionWithClass:self.class
                                                           selector:_cmd];
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
        @throw [CBXException withMessage:@"Only gestures with coordinates are supported"];
    }
    
    // Testmanagerd calls are async
    __block NSError *err;
    [ThreadUtils runSync:^(BOOL *setToTrueWhenDone) {

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

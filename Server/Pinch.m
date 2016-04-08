
#import "Pinch.h"

@implementation Pinch
+ (NSString *)name { return @"pinch"; }

+ (NSArray <NSString *> *)optionalKeys {
    return @[
             CB_DURATION_KEY,
             CB_AMOUNT_KEY,
             CB_PINCH_DIRECTION_KEY
             ];
}

- (XCSynthesizedEventRecord *)eventWithCoordinates:(NSArray<Coordinate *> *)coordinates {
    XCSynthesizedEventRecord *event = [[XCSynthesizedEventRecord alloc] initWithName:self.class.name
                                                                interfaceOrientation:0];
    
    CGPoint center = coordinates[0].cgpoint;
    float duration = [self duration];
    float amount = [self amount];
    NSString *direction = [self direction];
    
    CGPoint p1 = center,
    p2 = center;
    
    //TODO: let user specify orientation of pinch?
    p1.x -= amount;
    p2.x += amount;
    
    for (NSValue *v in @[ [NSValue valueWithCGPoint:p1], [NSValue valueWithCGPoint:p2]]) {
        if ([direction isEqualToString:CB_PINCH_OUT]) {
            XCPointerEventPath *path = [[XCPointerEventPath alloc] initForTouchAtPoint:center
                                                                                offset:0];
            
            [path moveToPoint:[v CGPointValue] atOffset:duration];
            [path liftUpAtOffset:duration + CB_GESTURE_EPSILON];
            [event addPointerEventPath:path];
        } else {
            XCPointerEventPath *path = [[XCPointerEventPath alloc] initForTouchAtPoint:[v CGPointValue]
                                                                                offset:0];
            [path moveToPoint:center atOffset:duration];
            [path liftUpAtOffset:duration + CB_GESTURE_EPSILON];
            [event addPointerEventPath:path];
        }
    }
    
    return event;
}

- (XCTouchGesture *)gestureWithCoordinates:(NSArray<Coordinate *> *)coordinates {
    XCTouchGesture *gesture = [[XCTouchGesture alloc] initWithName:self.class.name];
    
    CGPoint center = coordinates[0].cgpoint;
    float duration = [self duration];
    float amount = [self amount];
    NSString *direction = [self direction];
    
    CGPoint p1 = center,
            p2 = center;
    
    //TODO: let user specify orientation of pinch?
    p1.x -= amount;
    p2.x += amount;
    
    for (NSValue *v in @[ [NSValue valueWithCGPoint:p1], [NSValue valueWithCGPoint:p2]]) {
        if ([direction isEqualToString:CB_PINCH_OUT]) {
            XCTouchPath *path = [[XCTouchPath alloc] initWithTouchDown:center
                                                           orientation:0
                                                                offset:0];
            [path moveToPoint:[v CGPointValue] atOffset:duration];
            [path liftUpAtPoint:[v CGPointValue]
                         offset:duration + CB_GESTURE_EPSILON];
            [gesture addTouchPath:path];
        } else {
            XCTouchPath *path = [[XCTouchPath alloc] initWithTouchDown:[v CGPointValue]
                                                           orientation:0
                                                                offset:0];
            [path moveToPoint:center atOffset:duration];
            [path liftUpAtPoint:center
                         offset:duration + CB_GESTURE_EPSILON];
            [gesture addTouchPath:path];
        }
    }
    
    return gesture;
}
@end

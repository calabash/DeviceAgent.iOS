
#import "Pinch.h"

@implementation Pinch
+ (NSString *)name { return @"pinch"; }

+ (NSArray <NSString *> *)optionalKeys {
    return @[
             CBX_DURATION_KEY,
             CBX_PINCH_AMOUNT_KEY,
             CBX_PINCH_DIRECTION_KEY
             ];
}

- (XCSynthesizedEventRecord *)eventWithCoordinates:(NSArray<Coordinate *> *)coordinates {
    XCSynthesizedEventRecord *event = [[XCSynthesizedEventRecord alloc] initWithName:self.class.name
                                                                interfaceOrientation:0];
    
    CGPoint center = coordinates[0].cgpoint;
    float duration = [self duration];
    float amount = [self pinchAmount];
    NSString *direction = [self pinchDirection];
    
    CGPoint p1 = center,
    p2 = center;
    
    //TODO: let user specify orientation of pinch?
    p1.x -= amount;
    p2.x += amount;
    
    for (NSValue *v in @[ [NSValue valueWithCGPoint:p1], [NSValue valueWithCGPoint:p2]]) {
        if ([direction isEqualToString:CBX_PINCH_IN]) { //Zoom in
            XCPointerEventPath *path = [[XCPointerEventPath alloc] initForTouchAtPoint:center
                                                                                offset:0];
            
            [path moveToPoint:[v CGPointValue] atOffset:duration];
            [path liftUpAtOffset:duration + CBX_GESTURE_EPSILON];
            [event addPointerEventPath:path];
        } else {
            XCPointerEventPath *path = [[XCPointerEventPath alloc] initForTouchAtPoint:[v CGPointValue]
                                                                                offset:0];
            [path moveToPoint:center atOffset:duration];
            [path liftUpAtOffset:duration + CBX_GESTURE_EPSILON];
            [event addPointerEventPath:path];
        }
    }
    
    return event;
}

- (XCTouchGesture *)gestureWithCoordinates:(NSArray<Coordinate *> *)coordinates {
    XCTouchGesture *gesture = [[XCTouchGesture alloc] initWithName:self.class.name];

    UIInterfaceOrientation orientation = [[Application currentApplication]
                                          interfaceOrientation];

    CGPoint center = coordinates[0].cgpoint;
    float duration = [self duration];
    float amount = [self pinchAmount];
    NSString *direction = [self pinchDirection];
    
    CGPoint p1 = center,
            p2 = center;
    
    //TODO: let user specify orientation of pinch?
    p1.x -= amount;
    p2.x += amount;
    
    for (NSValue *v in @[ [NSValue valueWithCGPoint:p1], [NSValue valueWithCGPoint:p2]]) {
        if ([direction isEqualToString:CBX_PINCH_IN]) { //Zoom in
            XCTouchPath *path = [[XCTouchPath alloc] initWithTouchDown:center
                                                           orientation:0
                                                                offset:0];
            [path moveToPoint:[v CGPointValue] atOffset:duration];
            [path liftUpAtPoint:[v CGPointValue]
                         offset:duration + CBX_GESTURE_EPSILON];
            [gesture addTouchPath:path];
        } else {
            XCTouchPath *path = [[XCTouchPath alloc] initWithTouchDown:[v CGPointValue]
                                                           orientation:orientation
                                                                offset:0];
            [path moveToPoint:center atOffset:duration];
            [path liftUpAtPoint:center
                         offset:duration + CBX_GESTURE_EPSILON];
            [gesture addTouchPath:path];
        }
    }
    
    return gesture;
}
@end

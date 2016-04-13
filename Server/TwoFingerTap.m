
#import "TwoFingerTap.h"

@implementation TwoFingerTap

+ (NSString *)name { return @"two_finger_tap"; }

- (XCSynthesizedEventRecord *)eventWithCoordinates:(NSArray<Coordinate *> *)coordinates {
    XCSynthesizedEventRecord *event = [[XCSynthesizedEventRecord alloc]
                                       initWithName:self.class.name
                                       interfaceOrientation:0];
    
    float duration = [self duration];

    CGPoint coordinate = coordinates[0].cgpoint;

    // TODO Add argument for orientation of fingers.  At the moment we assume
    // the fingers are horizontal (touch happens on the same y coordinate).

    // The coordinate passed is the center of the view.  Each finger is
    // assumed to be 30 pt so the center of each finger is 15 pt from the
    // center of the view.
    CGFloat xOffset = 15.0;
    CGPoint leftFinger = CGPointMake(coordinate.x + xOffset, coordinate.y);
    CGPoint rightFinger = CGPointMake(coordinate.x - xOffset, coordinate.y);

    XCPointerEventPath *leftTap, *rightTap;
    leftTap = [[XCPointerEventPath alloc] initForTouchAtPoint:leftFinger
                                                       offset:0];
    [leftTap liftUpAtOffset:duration];
    rightTap = [[XCPointerEventPath alloc] initForTouchAtPoint:rightFinger
                                                        offset:0];
    [rightTap liftUpAtOffset:duration];

    [event addPointerEventPath:leftTap];
    [event addPointerEventPath:rightTap];

    return event;
}

- (XCTouchGesture *)gestureWithCoordinates:(NSArray<Coordinate *> *)coordinates {
    XCTouchGesture *gesture = [[XCTouchGesture alloc] initWithName:self.class.name];
    
    float duration = [self duration];

    CGPoint coordinate = coordinates[0].cgpoint;

    // TODO Add argument for orientation of fingers.  At the moment we assume
    // the fingers are horizontal (touch happens on the same y coordinate).

    // The coordinate passed is the center of the view.  Each finger is
    // assumed to be 30 pt so the center of each finger is 15 pt from the
    // center of the view.
    CGFloat xOffset = 15.0;
    CGPoint leftFinger = CGPointMake(coordinate.x + xOffset, coordinate.y);
    CGPoint rightFinger = CGPointMake(coordinate.x - xOffset, coordinate.y);

    XCTouchPath *leftTap, *rightTap;

     leftTap = [[XCTouchPath alloc] initWithTouchDown:leftFinger
                                          orientation:0
                                               offset:0];

    [leftTap liftUpAtPoint:leftFinger offset:duration];
    rightTap = [[XCTouchPath alloc] initWithTouchDown:rightFinger
                                          orientation:0
                                               offset:0];
    [rightTap liftUpAtPoint:rightFinger offset:duration];

    [gesture addTouchPath:leftTap];
    [gesture addTouchPath:rightTap];
    
    return gesture;
}
@end

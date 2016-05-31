
#import "CoordinateQueryConfiguration.h"
#import "Touch.h"

@implementation Touch

+ (NSString *)name { return @"touch"; }

- (CBXTouchEvent *)cbxEventWithCoordinates:(NSArray <Coordinate *> *)coordinates {
    if (coordinates.count == 0) {
        @throw [InvalidArgumentException withFormat:@"%@ requires at least one coordinate.",  [self.class name]];
    }

    CGPoint coordinate = coordinates[0].cgpoint;
    TouchPath *path = [TouchPath withFirstTouchPoint:coordinate
                                         orientation:0
                                              offset:0.0];

    [path liftUpAfterSeconds:[self duration]];

    return [CBXTouchEvent withTouchPath:path];
}

- (XCSynthesizedEventRecord *)eventWithCoordinates:(NSArray<Coordinate *> *)coordinates {
    if (coordinates.count == 0) {
        @throw [InvalidArgumentException withFormat:@"%@ requires at least one coordinate.",  [self.class name]];
    }

    XCSynthesizedEventRecord *event = [[XCSynthesizedEventRecord alloc] initWithName:self.class.name
                                                                interfaceOrientation:0];

    CGPoint coordinate = coordinates[0].cgpoint;

    XCPointerEventPath *path = [[XCPointerEventPath alloc] initForTouchAtPoint:coordinate
                                                                        offset:0];

    float duration = [self duration];

    [path liftUpAtOffset:duration];


    [event addPointerEventPath:path];
    return event;
}

- (XCTouchGesture *)gestureWithCoordinates:(NSArray<Coordinate *> *)coordinates {
    if (coordinates.count == 0) {
        @throw [InvalidArgumentException withFormat:@"%@ requires at least one coordinate.",  [self.class name]];
    }

    XCTouchGesture *gesture = [[XCTouchGesture alloc] initWithName:self.class.name];

    CGPoint coordinate = coordinates[0].cgpoint;

    XCTouchPath *path = [[XCTouchPath alloc] initWithTouchDown:coordinate
                                                   orientation:0
                                                        offset:0];

    float duration = [self duration];

    [path liftUpAtPoint:coordinate
                 offset:duration];
    [gesture addTouchPath:path];
    return gesture;
}

@end

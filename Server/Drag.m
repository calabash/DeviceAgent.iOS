
#import "CoordinateQueryConfiguration.h"
#import "Drag.h"

@implementation Drag
+ (NSString *)name { return @"drag"; }

+ (NSArray <NSString *> *)optionalKeys { return @[CBX_DURATION_KEY, CBX_REPITITIONS_KEY]; }

- (void)validate {
    NSArray *coords = [[self.query.queryConfiguration asCoordinateQueryConfiguration] coordinates];
    if (!coords || coords.count < 2) {
        @throw [InvalidArgumentException withFormat:@"Expected at least 2 coordinates for drag, got %li",
                (long)coords.count];
    }
}

- (XCSynthesizedEventRecord *)eventWithCoordinates:(NSArray<Coordinate *> *)coordinates {
    XCSynthesizedEventRecord *event = [[XCSynthesizedEventRecord alloc] initWithName:self.class.name
                                                                interfaceOrientation:0];
    float duration = [self duration];
    float offset = duration;
    
    CGPoint coordinate = coordinates[0].cgpoint;
    XCPointerEventPath *path = [[XCPointerEventPath alloc] initForTouchAtPoint:coordinate
                                                                        offset:0];
    
    for (int i = 0; i < [self repititions]; i ++) {
        for (Coordinate *coord in coordinates) {
            if (coord == coordinates.firstObject) { continue; }
            offset += duration;
            coordinate = coord.cgpoint;
            [path moveToPoint:coordinate atOffset:offset];
        }
    }
    
    [path liftUpAtOffset:offset];
    [event addPointerEventPath:path];
    
    return event;
}

- (XCTouchGesture *)gestureWithCoordinates:(NSArray<Coordinate *> *)coordinates {
    XCTouchGesture *gesture = [[XCTouchGesture alloc] initWithName:self.class.name];
    
    CGPoint coordinate = coordinates[0].cgpoint;
    float duration = [self duration];
    float offset = duration;
    
    XCTouchPath *path = [[XCTouchPath alloc] initWithTouchDown:coordinate
                                                   orientation:0
                                                        offset:0];
    for (int i = 0; i < [self repititions]; i ++) {
        for (Coordinate *coord in coordinates) {
            if (coord == coordinates.firstObject) { continue; }
            offset += duration;
            coordinate = coord.cgpoint;
            [path moveToPoint:coordinate atOffset:offset];
        }
    }
    offset += CBX_GESTURE_EPSILON;
    
    [path liftUpAtPoint:coordinate
                 offset:offset];
    [gesture addTouchPath:path];
    return gesture;
}
@end

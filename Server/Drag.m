
#import "CoordinateQueryConfiguration.h"
#import "GeometryUtils.h"
#import "Drag.h"

@implementation Drag
+ (NSString *)name { return @"drag"; }

+ (NSArray <NSString *> *)optionalKeys {
    return @[CBX_DURATION_KEY,
             CBX_REPETITIONS_KEY,
             CBX_NUM_FINGERS_KEY];
}

- (void)validate {
    NSArray *coords = [[self.query.queryConfiguration asCoordinateQueryConfiguration] coordinates];
    if (!coords || coords.count < 2) {
        @throw [InvalidArgumentException withFormat:@"Expected at least 2 coordinates for drag, got %li",
                (long)coords.count];
    }
    
    if ([self numFingers] < CBX_MIN_NUM_FINGERS || [self numFingers] > CBX_MAX_NUM_FINGERS) {
        @throw [InvalidArgumentException withFormat:
                @"%@ must be between %d and %d, inclusive.",
                CBX_NUM_FINGERS_KEY,
                CBX_MIN_NUM_FINGERS,
                CBX_MAX_NUM_FINGERS];
    }
}


- (XCSynthesizedEventRecord *)eventWithCoordinates:(NSArray<Coordinate *> *)coordinates {
    XCSynthesizedEventRecord *event = [[XCSynthesizedEventRecord alloc] initWithName:self.class.name
                                                                interfaceOrientation:0];
    
    for (int fingerIndex = 0; fingerIndex < [self numFingers]; fingerIndex++ ) {
        float duration = [self duration];
        float offset = duration;
        
        CGPoint coordinate = coordinates[0].cgpoint;
        CGPoint fingerOffset = [GeometryUtils fingerOffsetForFingerIndex:fingerIndex];
        
        coordinate.x += fingerOffset.x;
        coordinate.y += fingerOffset.y;
        
        XCPointerEventPath *path = [[XCPointerEventPath alloc] initForTouchAtPoint:coordinate
                                                                            offset:0];
        
        for (int i = 0; i < [self repetitions]; i ++) {
            for (Coordinate *coord in coordinates) {
                if (coord == coordinates.firstObject) { continue; }
                offset += duration;
                coordinate = coord.cgpoint;
                [path moveToPoint:coordinate atOffset:offset];
            }
        }
        
        [path liftUpAtOffset:offset];
        
        
        [event addPointerEventPath:path];
    }
    
    return event;
}

- (XCTouchGesture *)gestureWithCoordinates:(NSArray<Coordinate *> *)coordinates {
    XCTouchGesture *gesture = [[XCTouchGesture alloc] initWithName:self.class.name];
    
    for (int fingerIndex = 0; fingerIndex < [self numFingers]; fingerIndex++ ) {
        CGPoint fingerOffset = [GeometryUtils fingerOffsetForFingerIndex:fingerIndex];
        CGPoint coordinate = coordinates[0].cgpoint;
        
        coordinate.x += fingerOffset.x;
        coordinate.y += fingerOffset.y;
        
        float duration = [self duration];
        float offset = duration;
        
        XCTouchPath *path = [[XCTouchPath alloc] initWithTouchDown:coordinate
                                                       orientation:0
                                                            offset:0];
        for (int i = 0; i < [self repetitions]; i ++) {
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
    }
    return gesture;
}
@end

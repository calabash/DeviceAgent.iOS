
#import "CoordinateQueryConfiguration.h"
#import "DoubleTap.h"

@implementation DoubleTap

+ (NSString *)name { return @"double_tap"; }

- (void)validate {
    if ([self.query isCoordinateQuery]) {
        if ([self.query.queryConfiguration asCoordinateQueryConfiguration].coordinates) {
            @throw [InvalidArgumentException withFormat:
                    @"'%@' key not supported for %@. use '%@'.",
                    CBX_COORDINATES_KEY,
                    [self.class name],
                    CBX_COORDINATE_KEY];
        }
    }
    //TODO: should this throw an exception?
    if ([self duration] >= 0.5) {
        NSLog(@"WARNING: Having a tap duration greater than 0.5 will trigger a LongPress, not a tap.");
    }
}

- (XCSynthesizedEventRecord *)eventWithCoordinates:(NSArray<Coordinate *> *)coordinates {
    XCSynthesizedEventRecord *event = [[XCSynthesizedEventRecord alloc] initWithName:self.class.name
                                                                interfaceOrientation:0];
    
    CGPoint coordinate = coordinates[0].cgpoint;
    
    XCPointerEventPath *path = [[XCPointerEventPath alloc] initForTouchAtPoint:coordinate
                                                                        offset:0];
    
    float duration = [self duration];
    float offset = duration;
    
    [path liftUpAtOffset:offset];
    [event addPointerEventPath:path]; //tap 1
    
    offset += CBX_DOUBLE_TAP_PAUSE_DURATION;
    
    path = [[XCPointerEventPath alloc] initForTouchAtPoint:coordinate
                                                    offset:offset];
    
    offset += duration;
    [path liftUpAtOffset:offset];
    [event addPointerEventPath:path]; //tap 2
    
    return event;
}

- (XCTouchGesture *)gestureWithCoordinates:(NSArray<Coordinate *> *)coordinates {
    XCTouchGesture *gesture = [[XCTouchGesture alloc] initWithName:self.class.name];
    
    CGPoint coordinate = coordinates[0].cgpoint;
    
    XCTouchPath *path = [[XCTouchPath alloc] initWithTouchDown:coordinate
                                                   orientation:0
                                                        offset:0];
    
    float duration = [self duration];
    float offset = duration;
    
    [path liftUpAtPoint:coordinate
                 offset:offset];
    [gesture addTouchPath:path]; //tap 1
    
    offset += CBX_DOUBLE_TAP_PAUSE_DURATION;
    
    path = [[XCTouchPath alloc] initWithTouchDown:coordinate
                                      orientation:0
                                           offset:offset];
    
    offset += duration;
    
    [path liftUpAtPoint:coordinate
                 offset:offset];
    [gesture addTouchPath:path]; //tap 2
    return gesture;
}
@end

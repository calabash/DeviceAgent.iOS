
#import "CoordinateQueryConfiguration.h"
#import "GeometryUtils.h"
#import "Drag.h"

@implementation Drag
+ (NSString *)name { return @"drag"; }

+ (NSArray <NSString *> *)optionalKeys {
    return @[CBX_DURATION_KEY,
             CBX_NUM_FINGERS_KEY];
}

- (void)validate {
    NSArray *coords = [[self.query.queryConfiguration asCoordinateQueryConfiguration] coordinates];
    if (!coords || coords.count < 2) {
        @throw [InvalidArgumentException withFormat:@"Expected at least 2 coordinates for drag, got %li",
                (long)coords.count];
    }
    
    if ([self.query.queryConfiguration asCoordinateQueryConfiguration].coordinate) {
        @throw [InvalidArgumentException withMessage:
                @"Drag gesture can not accept 'coordinate' as a specifier. Use 'coordinates' instead."];
    }
    
    if ([self numFingers] < CBX_MIN_NUM_FINGERS || [self numFingers] > CBX_MAX_NUM_FINGERS) {
        @throw [InvalidArgumentException withFormat:
                @"%@ must be between %d and %d, inclusive.",
                CBX_NUM_FINGERS_KEY,
                CBX_MIN_NUM_FINGERS,
                CBX_MAX_NUM_FINGERS];
    }
}

- (CBXTouchEvent *)cbxEventWithCoordinates:(NSArray<Coordinate *> *)coordinates {
    CBXTouchEvent *event = [CBXTouchEvent new];

    long long orientation = [[Application currentApplication]
                             longLongInterfaceOrientation];

    for (int fingerIndex = 0; fingerIndex < [self numFingers]; fingerIndex++ ) {
        CGPoint fingerOffset = [GeometryUtils fingerOffsetForFingerIndex:fingerIndex];
        CGPoint coordinate = coordinates[0].cgpoint;
        
        coordinate.x += fingerOffset.x;
        coordinate.y += fingerOffset.y;
        
        float duration = [self duration];
        float offset = duration;

        TouchPath *path = [TouchPath withFirstTouchPoint:coordinate orientation:orientation];
        for (int i = 0; i < [self repetitions]; i ++) {
            for (Coordinate *coord in coordinates) {
                if (coord == coordinates.firstObject) { continue; }
                offset += duration;
                coordinate = coord.cgpoint;
                coordinate.x += fingerOffset.x;
                coordinate.y += fingerOffset.y;
                [path moveToNextPoint:coordinate afterSeconds:offset];
            }
        }
        offset += CBX_GESTURE_EPSILON;
        
        [path liftUpAfterSeconds:offset];
        [event addTouchPath:path];
    }
    
    return event;
}
@end

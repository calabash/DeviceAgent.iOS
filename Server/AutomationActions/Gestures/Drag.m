
#import "CoordinateQueryConfiguration.h"
#import "GeometryUtils.h"
#import "Drag.h"

@implementation Drag
+ (NSString *)name { return @"drag"; }

+ (NSArray <NSString *> *)optionalKeys {
    return @[CBX_ALLOW_INERTIA_DRAG_KEY,
             CBX_DURATION_KEY,
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

    UIInterfaceOrientation orientation = [[Application currentApplication]
                                          interfaceOrientation];
    
    for (int fingerIndex = 0; fingerIndex < [self numFingers]; fingerIndex++ ) {
        CGPoint fingerOffset = [GeometryUtils fingerOffsetForFingerIndex:fingerIndex];
        CGPoint point = coordinates[0].cgpoint;

        point.x += fingerOffset.x;
        point.y += fingerOffset.y;

        float duration = [self duration];
        float offset = 0.0;

        for (int i = 0; i < [self repetitions]; i ++) {
            TouchPath *path = [TouchPath withFirstTouchPoint:point orientation:orientation];

            for (Coordinate *coordinate in coordinates) {
                if (coordinate == coordinates.firstObject) { continue; }
                offset += duration;

                // Add an additional point to halt inertia.
                if (![self allowDragToHaveInertia] && coordinate == coordinates.lastObject) {
                    Coordinate *previousCoord = coordinates[coordinates.count - 2];
                    CGPoint haltPoint = [Drag pointByApplyingHaltDistanceToCoordinate:coordinate
                                                                   previousCoordinate:previousCoord];
                    haltPoint.x += fingerOffset.x;
                    haltPoint.y += fingerOffset.y;
                    [path moveToNextPoint:haltPoint afterSeconds:offset];
                    offset += 0.05;
                }

                point = coordinate.cgpoint;
                point.x += fingerOffset.x;
                point.y += fingerOffset.y;
                [path moveToNextPoint:point afterSeconds:offset];
            }

            [path liftUpAfterSeconds:offset];
            [event addTouchPath:path];

            offset += CBX_GESTURE_EPSILON;
        }
    }

    return event;
}

+ (CGPoint)pointByApplyingHaltDistanceToCoordinate:(Coordinate *)coordinate
                                previousCoordinate:(Coordinate *)previousCoordinate {

    CGPoint point = coordinate.cgpoint;
    CGPoint previousPoint = previousCoordinate.cgpoint;
    CGFloat dragHaltDistance = 2;

    if (point.x > previousPoint.x) {
        point.x += dragHaltDistance;
    } else if (point.x < previousPoint.x) {
        point.x -= dragHaltDistance;
    }

    if (point.y > previousPoint.y) {
        point.y += dragHaltDistance;
    } else if (point.y < previousPoint.y) {
        point.y -= dragHaltDistance;
    }
    return point;
}

@end


#import "Rotate.h"
#import "CBX-XCTest-Umbrella.h"
#import "XCTest+CBXAdditions.h"
#import "Application.h"
#import "CBXTouchEvent.h"
#import "InvalidArgumentException.h"
#import "CBXConstants.h"
#import "Coordinate.h"
#import "TouchPath.h"
#import "Gesture+Options.h"

typedef NS_ENUM(short, ClockDirection) {
    kClockDirectionClockwise = 1,
    kClockDirectionCounterClockwise = 2
};

@implementation Rotate

+ (NSString *)name { return @"rotate"; }

- (void)validate {
    if ([self degrees] < 0) {
        @throw [InvalidArgumentException withFormat:
                @"%@ must be a non-negative number. Specify direction with %@ or %@",
                CBX_DEGREES_KEY,
                CBX_CLOCKWISE_KEY,
                CBX_COUNTERCLOCKWISE_KEY];
    }

    if ([self rotationStart] < CBX_MIN_ROTATION_START ||
        [self rotationStart] > CBX_MAX_ROTATION_START) {
        @throw [InvalidArgumentException withFormat:
                @"%@ must be between %f and %f, inclusive.",
                CBX_ROTATION_START_KEY,
                CBX_MIN_ROTATION_START,
                CBX_MAX_ROTATION_START];
    }
}

+ (NSArray <NSString *> *)optionalKeys {
    return @[
             CBX_DURATION_KEY,
             CBX_DEGREES_KEY,
             CBX_ROTATION_START_KEY,
             CBX_ROTATION_DIRECTION_KEY,
             CBX_RADIUS_KEY,
             ];
}

- (ClockDirection)directionFromString:(NSString *)dirString {
    if ([[dirString lowercaseString] isEqualToString:CBX_CLOCKWISE_KEY])
        return kClockDirectionClockwise;
    else if ([[dirString lowercaseString] isEqualToString:CBX_COUNTERCLOCKWISE_KEY])
        return kClockDirectionCounterClockwise;
    @throw [InvalidArgumentException withFormat:
            @"'%@' is not a valid direction. Expected '%@' or '%@'",
            dirString,
            CBX_CLOCKWISE_KEY,
            CBX_COUNTERCLOCKWISE_KEY];

}

float dtor(float degrees) { return degrees * (M_PI / 180); }

- (NSArray<Coordinate *> *)circleRadiusPointsFromDegrees:(float)start
                                                rotateBy:(float)rotationDegrees
                                                  radius:(float)radius
                                               direction:(ClockDirection)direction
                                                  offset:(CGPoint)offset {
    float x,
        y,
        degrees = start,
        increment = CBX_ROTATE_INCREMENT_DEGREES <= rotationDegrees ?
        CBX_ROTATE_INCREMENT_DEGREES :
        rotationDegrees / 2.0;

    NSMutableArray <Coordinate *> *coordinates = [NSMutableArray array];

    while (rotationDegrees > 0) {
        x = (cosf(dtor(degrees)) * radius) + offset.x;
        y = (sinf(dtor(degrees)) * radius) + offset.y;

        rotationDegrees -= increment;
        degrees += direction == kClockDirectionClockwise ? increment : -increment;
        [coordinates addObject:[Coordinate fromRaw:CGPointMake(x, y)]];

    }

    return coordinates;
}

- (NSArray<NSArray<Coordinate *> *> *)setup:(NSArray <Coordinate *> *)coordinates {
    if (coordinates.count == 0) {
        @throw [InvalidArgumentException withFormat:@"%@ requires a coordinate", NSStringFromClass(self.class)];
    }

    CGPoint center = coordinates[0].cgpoint;

    ClockDirection cd = [self directionFromString:[self rotateDirection]];
    NSArray<Coordinate *> *coords1 = [self circleRadiusPointsFromDegrees:[self rotationStart]
                                                                rotateBy:[self degrees]
                                                                  radius:[self radius]
                                                               direction:cd
                                                                  offset:center];

    float oppositeStart = [self rotationStart] - 180;
    NSArray<Coordinate *> *coords2 = [self circleRadiusPointsFromDegrees:oppositeStart
                                                                rotateBy:[self degrees]
                                                                  radius:[self radius]
                                                               direction:cd
                                                                  offset:center];

    return @[coords1, coords2];
}

- (CBXTouchEvent *)cbxEventWithCoordinates:(NSArray<Coordinate *> *)coordinates {
    NSArray<NSArray<Coordinate *> *> *circleCoords = [self setup:coordinates];
    
    UIInterfaceOrientation orientation = [[Application currentApplication]
                                          interfaceOrientation];

    CBXTouchEvent *event = [CBXTouchEvent new];


    float timeIncrement = [self rotateDuration] / circleCoords[0].count;
    for (NSArray<Coordinate *> *fingerCoords in circleCoords) {
        float offset = 0;
        CGPoint c = fingerCoords[0].cgpoint;
        TouchPath *path = [TouchPath withFirstTouchPoint:c orientation:orientation];

        for (Coordinate *coord in fingerCoords) {
            if (coord == fingerCoords[0]) continue; //we've already done it
            [path moveToNextPoint:coord.cgpoint afterSeconds:(offset += timeIncrement)];
        }
        [path liftUpAfterSeconds:offset];
        [event addTouchPath:path];
    }

    return event;
}




@end


#import "CoordinateQueryConfiguration.h"
#import "Coordinate.h"
#import "Touch.h"
#import "Application.h"

@interface Touch ()

+ (NSArray <Coordinate *> *)fingerCoordinatesWithCenter:(CGPoint)point
                                                fingers:(NSUInteger)fingers;

@end

@implementation Touch

+ (NSString *)name { return @"touch"; }

+ (NSArray <NSString *> *)optionalKeys {
    return @[CBX_REPETITIONS_KEY, CBX_DURATION_KEY, CBX_NUM_FINGERS_KEY];
}

- (void)validate {
    if ([self.query.queryConfiguration isCoordinateQuery]) {
        NSArray *coordinates = [[self.query.queryConfiguration
                                 asCoordinateQueryConfiguration] coordinates];
        if (coordinates) {
          @throw [InvalidArgumentException
                  withFormat:@"'coordinates' is an invalid key; use 'coordinate'. \n\
                  The Touch gesture only accepts single coordinates."];
        }
    }

    if ([self numFingers] >= CBX_MAX_NUM_FINGERS) {
      @throw [InvalidArgumentException
              withFormat:@"Number of fingers: %@ is invalid. The max number of \
              fingers for a touch is %@",
              @([self numFingers]),
              @(CBX_MAX_NUM_FINGERS)];
    }
}

- (CBXTouchEvent *)cbxEventWithCoordinates:(NSArray <Coordinate *> *)coordinates {

    UIInterfaceOrientation orientation = [Gesture interfaceOrientation];
    CGPoint coordinate = coordinates[0].cgpoint;

    float duration = [self duration];
    float offset = duration;

    NSUInteger numberFingers = [self numFingers];
    NSArray <Coordinate *> *fingerCoordinates;
    fingerCoordinates = [Touch fingerCoordinatesWithCenter:coordinate
                                                   fingers:numberFingers];

    CBXTouchEvent *touchEvent = nil;

    for (NSUInteger repsIndex = 0; repsIndex < [self repetitions]; repsIndex++) {
        NSMutableArray <TouchPath *> *paths = [NSMutableArray arrayWithCapacity:numberFingers];
        if (repsIndex == 0) {
            for (Coordinate *fingerCoord in fingerCoordinates) {
                [paths addObject:[TouchPath withFirstTouchPoint:fingerCoord.cgpoint
                                                    orientation:orientation]];
            }
        } else {
            for (Coordinate *fingerCoord in fingerCoordinates) {
                [paths addObject:[TouchPath withFirstTouchPoint:fingerCoord.cgpoint
                                                    orientation:orientation
                                                         offset:offset]];
            }
            offset += CBX_DOUBLE_TAP_PAUSE_DURATION;
        }

        for (TouchPath *path in paths) {
            [path liftUpAfterSeconds:offset];
        }

        offset += CBX_DOUBLE_TAP_PAUSE_DURATION;

        for (TouchPath *path in paths) {
            if (touchEvent) {
                [touchEvent addTouchPath:path];
            } else {
                touchEvent = [CBXTouchEvent withTouchPath:path];
            }
        }
        offset += duration;
    }

    NSLog(@"touch event: %@", touchEvent);
    return touchEvent;
}

// TODO Add argument for orientation of fingers.  At the moment we assume
// the fingers are horizontal (touch happens on the same y coordinate).

// The coordinate passed is the center of the view and we assume the fingers
// are touching.  Therefore, we use half a finger width to offset the touch.
+ (NSArray <Coordinate *> *)fingerCoordinatesWithCenter:(CGPoint)point
                                                fingers:(NSUInteger)fingers {
    NSMutableArray <Coordinate *> *array = [NSMutableArray arrayWithCapacity:fingers];
    switch (fingers) {
        case 1: {
            [array addObject:[Coordinate fromRaw:point]];
            break;
        }

        case 2: {
            CGFloat xOffset = CBX_FINGER_WIDTH / 2.0;
            CGPoint left = CGPointMake(point.x - xOffset, point.y);
            CGPoint right = CGPointMake(point.x + xOffset, point.y);
            [array addObject:[Coordinate fromRaw:left]];
            [array addObject:[Coordinate fromRaw:right]];
            break;
        }

        case 3: {
            CGPoint left = CGPointMake(point.x - CBX_FINGER_WIDTH, point.y);
            CGPoint middle = point;
            CGPoint right = CGPointMake(point.x + CBX_FINGER_WIDTH, point.y);
            [array addObject:[Coordinate fromRaw:left]];
            [array addObject:[Coordinate fromRaw:middle]];
            [array addObject:[Coordinate fromRaw:right]];
            break;
        }

        case 4: {
            CGPoint leftMost = CGPointMake(point.x - (CBX_FINGER_WIDTH +
                                                      CBX_FINGER_WIDTH/2.0),
                                                       point.y);
            CGPoint left = CGPointMake(point.x - (CBX_FINGER_WIDTH/2.0), point.y);
            CGPoint right = CGPointMake(point.x + (CBX_FINGER_WIDTH/2.0), point.y);
            CGPoint rightMost = CGPointMake(point.x + (CBX_FINGER_WIDTH +
                                                      CBX_FINGER_WIDTH/2.0),
                                                       point.y);

            [array addObject:[Coordinate fromRaw:leftMost]];
            [array addObject:[Coordinate fromRaw:left]];
            [array addObject:[Coordinate fromRaw:right]];
            [array addObject:[Coordinate fromRaw:rightMost]];
            break;
        }
        default: {
            @throw [InvalidArgumentException
                    withFormat:@"Number of fingers: %@ is invalid. The max number of \
                    fingers for a touch is %@",
                    @(fingers),
                    @(CBX_MAX_NUM_FINGERS)];
            break;
        }
    }
    return [NSArray <Coordinate *> arrayWithArray:array];
}
@end

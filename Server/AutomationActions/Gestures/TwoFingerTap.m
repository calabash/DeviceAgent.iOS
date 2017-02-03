
#import "TwoFingerTap.h"
#import "CBXConstants.h"
#import "CoordinateQueryConfiguration.h"
#import "Coordinate.h"
#import "XCUIApplication.h"
#import "XCUIApplication+DeviceAgentAdditions.h"

@implementation TwoFingerTap

+ (NSString *)name { return @"two_finger_tap"; }

+ (NSArray <NSString *> *)optionalKeys {
    return @[CBX_DURATION_KEY];
}

- (void)validate {
    NSArray *coordinates = [[self.query.queryConfiguration
                             asCoordinateQueryConfiguration] coordinates];
    if (coordinates) {
      @throw [InvalidArgumentException
              withFormat:@"'coordinates' is an invalid key; use 'coordinate'. \n\
              The two_finger_tap gesture only accepts single coordinates."];
    }

    if ([self duration] >= 0.5) {
        @throw [InvalidArgumentException withFormat:
                @"Duration %@ is too long: must be less than %@",
                @([self duration]),
                @(CBX_MIN_LONG_PRESS_DURATION)];
    }
}

- (CBXTouchEvent *)cbxEventWithCoordinates:(NSArray <Coordinate *> *)coordinates {

    long long orientation = [[Application currentApplication]
                             longLongInterfaceOrientation];

    CGPoint coordinate = coordinates[0].cgpoint;

    // Increase the duration by a little to trigger long press gestures.
    // For example, a recognizer with 1.0 minimum duration will not be
    // triggered by a 1.0 duration, but it will be triggered by a 1.01
    // duration.
    float duration = [self duration] + 0.01;
    float offset = duration;

    // TODO Add argument for orientation of fingers.  At the moment we assume
    // the fingers are horizontal (touch happens on the same y coordinate).

    // The coordinate passed is the center of the view and we assume the fingers
    // are touching.  Therefore, we use half a finger width to offset the touch.
    CGFloat xOffset = CBX_FINGER_WIDTH/2.0;
    CGPoint leftFinger = CGPointMake(coordinate.x + xOffset, coordinate.y);
    CGPoint rightFinger = CGPointMake(coordinate.x - xOffset, coordinate.y);


    TouchPath *leftPath = [TouchPath withFirstTouchPoint:leftFinger
                                             orientation:orientation];
    TouchPath *rightPath = [TouchPath withFirstTouchPoint:rightFinger
                                              orientation:orientation];
    offset += CBX_DOUBLE_TAP_PAUSE_DURATION;

    [leftPath liftUpAfterSeconds:offset];
    [rightPath liftUpAfterSeconds:offset];

    CBXTouchEvent *touchEvent = [CBXTouchEvent withTouchPath:leftPath];
    [touchEvent addTouchPath:rightPath];

    DDLogDebug(@"two-finger tap event: %@", touchEvent);
    return touchEvent;
}

@end

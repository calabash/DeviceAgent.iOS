
#import "CoordinateQueryConfiguration.h"
#import "DoubleTap.h"
#import "XCUIApplication.h"
#import "XCUIApplication+DeviceAgentAdditions.h"

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
    
    if ([self duration] >= 0.5) {
        @throw [InvalidArgumentException withFormat:
                @"Duration %@ is too long: Must be less than %@",
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

    TouchPath *first = [TouchPath withFirstTouchPoint:coordinate
                                          orientation:orientation];
    [first liftUpAfterSeconds:offset];

    offset += CBX_DOUBLE_TAP_PAUSE_DURATION;

    TouchPath *second = [TouchPath withFirstTouchPoint:coordinate
                                           orientation:orientation
                                                offset:offset];
    offset += CBX_DOUBLE_TAP_PAUSE_DURATION;
    [second liftUpAfterSeconds:offset];

    CBXTouchEvent *touchEvent = [CBXTouchEvent withTouchPath:first];
    [touchEvent addTouchPath:second];

    DDLogDebug(@"double_tap event: %@", touchEvent);
    return touchEvent;
}

@end

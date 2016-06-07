
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
    
    if ([self duration] >= 0.5) {
        @throw [InvalidArgumentException withFormat:
                @"Duration %@ is too long: Must be less than %@",
                @([self duration]),
                @(CBX_MIN_LONG_PRESS_DURATION)];
    }
}

- (CBXTouchEvent *)cbxEventWithCoordinates:(NSArray <Coordinate *> *)coordinates {

    XCUIApplication *shared = [Application currentApplication];
    UIInterfaceOrientation orientation = [shared interfaceOrientation];
    CGPoint coordinate = coordinates[0].cgpoint;

    float duration = [self duration];
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

    NSLog(@"double_tap event: %@", touchEvent);
    return touchEvent;
}

@end

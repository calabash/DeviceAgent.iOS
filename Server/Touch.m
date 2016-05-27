
#import "CoordinateQueryConfiguration.h"
#import "Coordinate.h"
#import "Touch.h"
#import "Application.h"

@implementation Touch

+ (NSString *)name { return @"touch"; }

+ (NSArray <NSString *> *)optionalKeys {
    return @[CBX_REPETITIONS_KEY, CBX_DURATION_KEY];
}

- (void)validate {
    NSArray *coordinates = [[self.query.queryConfiguration
                             asCoordinateQueryConfiguration] coordinates];
    if (coordinates) {
      @throw [InvalidArgumentException
              withFormat:@"'coordinates' is an invalid key; use 'coordinate'. \n\
              The Touch gesture only accepts single coordinates."];
    }
}

- (CBXTouchEvent *)cbxEventWithCoordinates:(NSArray <Coordinate *> *)coordinates {

    XCUIApplication *shared = [Application currentApplication];
    UIInterfaceOrientation orientation = [shared interfaceOrientation];
    CGPoint coordinate = coordinates[0].cgpoint;

    float duration = [self duration];
    float offset = duration;

    CBXTouchEvent *touchEvent = nil;

    for (NSUInteger repsIndex = 0; repsIndex < [self repetitions]; repsIndex++) {
        TouchPath *path = nil;
        if (repsIndex == 0) {
            path = [TouchPath withFirstTouchPoint:coordinate
                                      orientation:orientation];
        } else {
            path = [TouchPath withFirstTouchPoint:coordinate
                                      orientation:orientation
                                           offset:offset];
            offset += CBX_DOUBLE_TAP_PAUSE_DURATION;
        }

        [path liftUpAfterSeconds:offset];
        offset += CBX_DOUBLE_TAP_PAUSE_DURATION;
        if (touchEvent) {
            [touchEvent addTouchPath:path];
        } else {
            touchEvent = [CBXTouchEvent withTouchPath:path];
        }
        offset += duration;
    }

    NSLog(@"touch event: %@", touchEvent);
    return touchEvent;
}

@end

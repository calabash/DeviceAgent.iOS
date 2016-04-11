
#import "Gesture+Options.h"

/*  
    Double tap a coordinate.  Use `duration` to set the hold time. Note that any duration > 0
    may result in UIGestureRecognizers not detecting the event as a proper double tap.
 */
@interface DoubleTap : Gesture<Gesture>
@end

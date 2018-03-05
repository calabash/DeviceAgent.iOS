
#import <Foundation/Foundation.h>
#import "Gesture.h"

/**
 Double tap an element. 
 
 **Warning**
 `duration` must be less than 0.5, else the gesture will fail 
 (durations >= 0.5 would result in two 'long press' gestures).
 
 ## Name
    @"double_tap"
 
 ## Required
 _none_
 
 ## Optional
 -  CBX_DURATION_KEY
 
 */
@interface DoubleTap : Gesture<Gesture>
@end

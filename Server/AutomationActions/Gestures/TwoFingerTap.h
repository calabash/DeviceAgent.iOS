
#import <Foundation/Foundation.h>
#import "Gesture.h"

/**
 Tap an element with two fingers
 
 **Warning**
 `duration` must be less than 0.5, else the gesture will fail
 (durations >= 0.5 would result in two 'long press' gestures).
 
 ## Name
    @"two_finger_tap"
 
 ## Required
 _none_
 
 ## Optional
 -  CBX_DURATION_KEY
 
 */
@interface TwoFingerTap : Gesture<Gesture>
@end

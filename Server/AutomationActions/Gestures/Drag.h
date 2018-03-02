
#import <Foundation/Foundation.h>
#import "Gesture.h"

/**
 Drag between any number of coordinates with up to 5 fingers.

 The positions of the fingers beyond the first are determined by
 +[GeometryUtils fingerOffsetForFingerIndex:] 
 
 You can repeat the gesture any number of times by using the `repetitions` key.
 
 **Warning**
 There is currently a bug with `duration` such that it is not evenly split between
 segments specified by the coordinates, and the gesture ends up taking longer than 
 `duration` seconds. The intended behavior is that the entire gesture will take 
 exactly `duration` seconds.
 
 ## Name
 @"Drag"
 
 ## Required
 _none_
 
 ## Optional
 -  CBX_DURATION_KEY
 -  CBX_NUM_FINGERS_KEY
 -  CBX_HOLD_DURATION_KEY
 -  CBX_FIRST_TOUCH_HOLD_DURATION_DRAG_KEY
 
 */
@interface Drag : Gesture<Gesture>
@end

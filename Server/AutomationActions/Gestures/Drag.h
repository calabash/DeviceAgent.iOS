
#import "Gesture+Options.h"

/**
 Drag between any number of coordinates with up to 5 fingers.

Currently, the positions of the fingers beyond the first are determined by 
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
 
 */
@interface Drag : Gesture<Gesture>
@end

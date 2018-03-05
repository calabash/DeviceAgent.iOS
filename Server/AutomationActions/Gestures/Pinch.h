
#import <Foundation/Foundation.h>
#import "Gesture.h"

/**
 Two-finger pinch.
 
 This is also known as zoom in or zoom out.
 
 Specify the amount of pinch (in UI points) with the `amount` key.  The default is 50.
 
 Specify the direction of the pinch ("in" or "out") with the `pinch_direction` key.
 The default behavior is to pinch "out" or "zoom out".

 Note that the behavior of pinch does not always match the gesture the user is performing.
 For example, "zooming out" on a map requires a pinch (fingers come together).  Zooming in
 requires a "reverse pinch" (fingers move away from each other).
 
 ## Name
 @"pinch"
 
 ## Required
 _none_
 
 ## Optional
 - CBX_DURATION_KEY,
 - CBX_PINCH_AMOUNT_KEY,
 - CBX_PINCH_DIRECTION_KEY
 
 */

@interface Pinch : Gesture<Gesture>
@end

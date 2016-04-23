
#import "Gesture+Options.h"

/**
 Two-finger pinch.
 
 Specify the amount of pinch (in UI points) with the `pinch_amount` key.
 Specify the direction of the pinch ("in" or "out") with the `pinch_direction` key.
 (E.g. on a map `pinch_direction : "in"` corresponds to zooming in,
 `pinch_direction : "out"` corresponds to zooming out).
 
 Defaults to pinching out (fingers come together, as though you were pinching someone.
 Gently, of course).
 
 
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

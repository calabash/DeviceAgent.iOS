
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import <Foundation/Foundation.h>
#import "Gesture.h"

/**
 Two-finger Rotation
 
 Rotates two fingers in a circular shape (clockwise 90º by default). 
 
 Use `radius` to control the size of the rotation circle. 
 The center of the circle will be the center of the element matched by the gesture query, 
 or the `coordinate` specified in the CoordinateQueryConfiguration. 
 
 Use `rotation_start` to determine where (in degrees) one finger will start. The other 
 finger will start 180º away from the first (opposite side of the circle). 0º is 3:00. 
 
 Use `degrees` to determine how many degrees to rotate around the circle. Defaul is 90º.
 
 Use `rotation_direction` to control which direction to rotate (clockwise or counterclockwise).
 
 Use `repetitions` to repeat the rotation. E.g. if you are trying to spin a dial 3 times, 
 you might do something like:
 
    {
        "degrees" : 360,
        "repetitions" : 3
    }
 
 `duration` applies to _each_ rotation, so if you do 3 rotations with duration 1, each
 rotation will last 1 second for a total of 3 seconds.
 
 ## Name
 @"rotate"
 
 ## Required
 _none_
 
 ## Optional
 -  CBX_DURATION_KEY,
 -  CBX_DEGREES_KEY,
 -  CBX_ROTATION_START_KEY,
 -  CBX_ROTATION_DIRECTION_KEY,
 -  CBX_RADIUS_KEY,
 
 */

@interface Rotate : Gesture<Gesture>
@end

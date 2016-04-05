//
//  CBDragCoordinate.h
//  CBXDriver
//
//  Created by Chris Fuentes on 3/20/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBCoordinateGesture.h"

/*
    Drag between any number of coordinates. Use `duration` to set the length of the drag time between points.
 */
@interface CBDragCoordinates : CBCoordinateGesture<CBGesture>
@end

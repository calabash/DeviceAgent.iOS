//
//  CBDragCoordinate.h
//  CBXDriver
//
//  Created by Chris Fuentes on 3/20/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBGesture+Options.h"

/*
    Drag between any number of coordinates. Use `duration` to set the length of the drag time between points.
 */
@interface CBDrag : CBGesture<CBGesture>
@end

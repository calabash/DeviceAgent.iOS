//
//  CBDoubleTapCoordinate.h
//  CBXDriver
//
//  Created by Chris Fuentes on 3/19/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBGesture+Options.h"

/*  
    Double tap a coordinate.  Use `duration` to set the hold time. Note that any duration > 0
    may result in UIGestureRecognizers not detecting the event as a proper double tap.
 */
@interface CBDoubleTap : CBGesture<CBGesture>
@end

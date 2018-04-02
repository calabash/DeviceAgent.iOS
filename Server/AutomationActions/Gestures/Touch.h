
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import <Foundation/Foundation.h>
#import "Gesture.h"

/**
 Touch an element for any length of time. 
 
 ## Name
 @"touch"
 
 ## Required
 _none_
 
 ## Optional
 -  CBX_DURATION_KEY
 -  CBX_REPETITIONS_KEY
 -  CBX_NUM_FINGERS_KEY
 
 */
@interface Touch : Gesture<Gesture>
@end


// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import <Foundation/Foundation.h>
#import "Gesture.h"


/**
Input a string of text (via iOS keyboard).

Assumes that some element already `isFirstResponder`.
 Accordingly, the input query for this gesture is _ignored_.

 ## Name
    @"enter_text"

 ## Required
 -  CBX_STRING_KEY

 ## Optional
 _none_

 */
@interface EnterText : Gesture <Gesture>

@end

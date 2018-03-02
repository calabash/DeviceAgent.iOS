
#import <Foundation/Foundation.h>
#import "Gesture.h"

/** 
 Input a string of text (via iOS keyboard).
 
 First performs a Touch on the result of its `query`, followed by
 sending the string of text. The assumption is that the element
 specified by the `query` will be some text-enabled element.
 
 ## Name
    @"enter_text_in"
 
 ## Required
 -  CBX_STRING_KEY
 
 ## Optional
 _none_
 
 */

@interface EnterTextIn : Gesture<Gesture>
@end

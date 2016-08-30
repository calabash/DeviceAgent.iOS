
#import <Foundation/Foundation.h>
#import "Gesture.h"

/**
 Factory class for creating gestures from raw JSON input.
 */
@interface GestureFactory : NSObject

/**
Creates and executes a gesture from `json` and then invokes a completion block synchronously.
 
 JSON should be of the form:
 
    {
        "gesture" : <gesture_name>,
        "specifiers" : { },
        "options" : { }
    }
 
 Roughly speaking, `gesture` will define which Gesture class to use, 
 `specifiers` will form the Query used to find the element(s) on which 
 to perform the Gesture, and `options` will be the parameters of the 
 Gesture itself.
 
 @param json JSON object from which to parse the gesture.
 @param completion Block to execute after gesture has been performed
 @return The Gesture performed
 */
+ (Gesture *)executeGestureWithJSON:(NSDictionary *)json completion:(CompletionBlock)completion;
@end

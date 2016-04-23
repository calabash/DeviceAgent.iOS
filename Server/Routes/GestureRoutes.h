//
//  GestureRotues.h
//  xcuitest-server
//

#import <Foundation/Foundation.h>
#import "CBXProtocols.h"

/**
 Routes for invoking gestures.
 
 ## POST @"/1.0/gesture"
     {
         "gesture" : <gesture_name>,
         "specifiers" : { },
         "options" : { }
     }
 
The `gesture_name` will correspond to the `name` returned by the Gesture class. 
 `specifiers will have keys corresponding to the `name` returned by QuerySpecifier classes.
 The options will vary by Gesture. 
 
 See Gesture, QuerySpecifier
 */
@interface GestureRoutes : NSObject<CBRouteProvider>
@end


#import <Foundation/Foundation.h>
#import "CBXProtocols.h"

/**
Routes for managing the life & death of an application and, to a lesser extent, 
 the test session itself.
 
 ## POST @"/session"
    { "bundleID" : <app bundle ID> }
 
 Launches app with `bundleID`. Note that `bundle_id` and `bundleId` are also accepted keys. 
 
 **WARNING**
 If the bundle ID currently matches no app on the device, undefined behavior will occurr. 
 Don't do it.
 

 ## DELETE /session # Terminates the current AUT

 ## POST /shutdown # Stops the DeviceAgent HTTP Server
 */
@interface SessionRoutes : NSObject<CBRouteProvider>
@end


#import <Foundation/Foundation.h>
#import "CBXProtocols.h"

/**
 Routes for managing the life & death of an application and, to a lesser extent,
 the test session itself.

 ## POST /session - Launches app with `bundle_id`.
    {

      # required
      "bundle_id" : "<app bundle ID>"

      # optional
      "launchArgs" : [< arguments to pass to AUT at launch >]
      "environment" : {< environment in which to launch AUT >}
      "terminate_aut_if_running" : true | false
     }

    Raises an exception if there is no application matching the bundle identifier.

 ## DELETE /session - Terminates the current AUT

 ## POST /shutdown - Stops the DeviceAgent HTTP Server
 */
@interface SessionRoutes : NSObject<CBRouteProvider>
@end

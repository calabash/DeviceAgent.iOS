
#import <Foundation/Foundation.h>
#import "CBXProtocols.h"

/**
 Routes relating to raw device events.

 ## POST @"/home"
 Press the home button

 ## POST @"/siri"
 Hold the home button long enough to invoke Siri

 ## POST @"/volume"
 Touch the volume controls

 ## POST @"/rotate-home-button-to"
 {
 orientation: UIDeviceOrientation
 seconds_to_sleep_after: how long to sleep after performing the rotation
 }
 Change the device orientation

 */
@interface DeviceEventRoutes : NSObject<CBRouteProvider>
@end

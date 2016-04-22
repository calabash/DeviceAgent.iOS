
#import <Foundation/Foundation.h>
#import "CBXProtocols.h"

/**
 Routes relating to raw device events. 
 
 ## POST @"/home"
 Press the home button
 
 ## POST @"/siri"
 Hold the home button long enough to invoke Siri
 

TODO: Orientation
 */
@interface DeviceEventRoutes : NSObject<CBRouteProvider>
@end

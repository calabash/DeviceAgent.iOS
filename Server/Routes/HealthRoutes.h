//
//  HealthRoute.h
//  xcuitest-server
//

#import "CBXProtocols.h"

/**
 Routes used to determine if the server is running. 
 
 ## GET @"/health"
 Should return a friendly message if the server is running. 
 
 ## GET @"/ping"
 Duplicate functionality
 Should return a friendly message if the server is running.
 */
@interface HealthRoutes : NSObject<CBRouteProvider>
@end

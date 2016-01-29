//
//  CBProtocols.h
//  xcuitest-server
//


#import "RoutingHTTPServer.h"

@protocol CBRoute <NSObject>
+ (void)addRoutesToServer:(RoutingHTTPServer *)server;
@end
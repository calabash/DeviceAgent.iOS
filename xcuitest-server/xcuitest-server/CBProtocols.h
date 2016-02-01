//
//  CBProtocols.h
//  xcuitest-server
//


#import "CBRoute.h"
@protocol CBRouteProvider <NSObject>
+ (NSArray<CBRoute *>*)getRoutes;
@end
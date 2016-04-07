//
//  CBProtocols.h
//  xcuitest-server
//


#import "CBRoute.h"
@protocol CBRouteProvider <NSObject>
@required
+ (NSArray<CBRoute *>*)getRoutes;
@end

@class JSONKeyValidator;
@protocol JSONKeyValidatorProvider<NSObject>
@required
+ (JSONKeyValidator *)validator;
@end
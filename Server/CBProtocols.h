//
//  CBProtocols.h
//  xcuitest-server
//


#import "CBXRoute.h"
@protocol CBRouteProvider <NSObject>
@required
+ (NSArray<CBXRoute *>*)getRoutes;
@end

@class JSONKeyValidator;
@protocol JSONKeyValidatorProvider<NSObject>
@required
+ (JSONKeyValidator *)validator;
@end
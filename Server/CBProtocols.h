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
@protocol JSONActionValidatorProvider<NSObject>
+ (JSONKeyValidator *)validator;
@end

#import <Foundation/Foundation.h>
#import "CoordinateQueryConfiguration.h"

/**
 Simple factory class for creating QueryConfiguration objects.
 */
@interface QueryConfigurationFactory : NSObject

/**
 Basic static factory constructor for creating a QueryConfiguration.
 
 **This should be used instead of direct instantiation, unless you're sure you know
 which class you want to instantiate.**
 
 @param json Raw key-value pairs which comprise the query configuration
 @param validator Used to validate the `json` input
 @return QueryConfiguration or CoordinateQueryConfiguration as appropriate, based on `json` input
 */
+ (QueryConfiguration *)configWithJSON:(NSDictionary *)json
                             validator:(JSONKeyValidator *)validator;
@end

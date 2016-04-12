
#import <Foundation/Foundation.h>
#import "JSONKeyValidator.h"

@interface ActionConfiguration : NSObject
/*
 Convenience indexing into raw json object
 */
- (id)objectForKeyedSubscript:(NSString *)key;

/*
 Creates a configuration object and validates the json inputs against
 required/optional specifiers.
 */
+ (instancetype)withJSON:(NSDictionary *)json
               validator:(JSONKeyValidator *)validator;

/*
 Checks if a given key exists. 
 */
- (BOOL)has:(NSString *)key;

/*
 Debuging / error logging
 */
@property (nonatomic, strong) NSDictionary *raw;

@end

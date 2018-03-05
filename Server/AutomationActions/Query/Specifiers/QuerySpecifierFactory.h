
#import <Foundation/Foundation.h>
#import "QuerySpecifier.h"

/**
 Factory class for creating QuerySelectors based on raw JSON input. 
 
 Every specifier is a key-value pair. The key determines the type of specifier, 
 and the value indicates what you are looking for when matching. 
 
 This factory matches on the specifier key and returns an appropriate gesture
 */
@interface QuerySpecifierFactory : NSObject

/**
 Runtime-generated list of currently supported selectors.
 Returns the `name` of every class conforming to the QuerySelector protocol.
 */
+ (NSArray <NSString *> *)supportedSpecifierNames;

/**
 Given a key-value pair, returns a QuerySelector of a type indicated by the 
 `key` which is set to match on `val`
 
 @param key Type of QuerySelector
 @param val Value to match
 @return a new QuerySelector
 @exception InvalidArgumentException Thrown if key is `nil` or doesn't match any of 
 the currently supported keys.
 */
+ (QuerySpecifier *)specifierWithKey:(NSString *)key value:(id)val;
@end

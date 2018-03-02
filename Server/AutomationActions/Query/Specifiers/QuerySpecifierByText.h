
#import <Foundation/Foundation.h>
#import "QuerySpecifier.h"

/**
 Specify elements by text.
 
 Elements may contain text in a variety of attributes, e.g. `label`, `id`, `title`, 
 `placeholderValue`. This QuerySpecifier will do an exact text match on any of these
 texty properties.
 
 ## Usage:
 
 { "text" : "String" }
 */

@interface QuerySpecifierByText : QuerySpecifier<QuerySpecifier>
/**
Properties considered during text match.
@return An array of string property keys which correspond to texty properties
 */
 
+ (NSArray <NSString *> *)textProperties;
@end

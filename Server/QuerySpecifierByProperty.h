
#import "QuerySpecifier.h"
#import "JSONUtils.h"

@interface QuerySpecifierByProperty : QuerySpecifier<QuerySpecifier>
+ (NSDictionary <NSString *, id> *)parseValue:(id)value; // @{ @"key" : string, @"value" : id }
@end

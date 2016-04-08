
#import "QuerySelector.h"
#import "JSONUtils.h"

@interface QuerySelectorProperty : QuerySelector<QuerySelector>
+ (NSDictionary <NSString *, id> *)parseValue:(id)value; // @{ @"key" : string, @"value" : id }
@end

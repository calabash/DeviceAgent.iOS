
#import "QuerySelector.h"
#import "QuerySelector.h"
@interface QuerySelectorFactory : QuerySelector
+ (NSArray <NSString *> *)supportedSelectorNames;
+ (QuerySelector *)selectorWithKey:(NSString *)key value:(id)val;
@end

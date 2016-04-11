
#import "QuerySelectorPropertyLike.h"

@implementation QuerySelectorPropertyLike
+ (NSString *)name { return @"property_like"; }

- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query {
    NSMutableString *predString = [NSMutableString string];
    NSDictionary *val = [QuerySelectorProperty parseValue:self.value];
    
    [predString appendFormat:@"%@ LIKE[cd] '*%@*'", val[@"key"], val[@"value"]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predString];
    return [query matchingPredicate:predicate];
}
@end

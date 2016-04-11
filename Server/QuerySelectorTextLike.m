
#import "QuerySelectorTextLike.h"

@implementation QuerySelectorTextLike

+ (NSString *)name { return @"text_like"; }

- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query {
    NSMutableString *predString = [NSMutableString string];
    for (NSString *prop in [QuerySelectorText textProperties]) {
        [predString appendFormat:@"%@ LIKE[cd] '*%@*'", prop, self.value];
        if (prop != [[QuerySelectorText textProperties] lastObject]) {
            [predString appendString:@" OR "];
        }
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predString];
    return [query matchingPredicate:predicate];
}
@end

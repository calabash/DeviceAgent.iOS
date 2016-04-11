
#import "QuerySelectorText.h"

@implementation QuerySelectorText
static NSArray <NSString *> *textProperties;
+ (void)load {
    textProperties = @[@"wdLabel", @"wdTitle", @"wdValue", @"wdPlaceholderValue"];
}

+ (NSArray <NSString *> *)textProperties {
    return textProperties;
}

+ (NSString *)name { return @"text"; }

- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query {
    /*
        TODO: Performance win with NSCompoundPredicate?
     */
    
    NSMutableString *predString = [NSMutableString string];
    for (NSString *prop in textProperties) {
        [predString appendFormat:@"%@ == '%@'", prop, self.value];
        if (prop != [textProperties lastObject]) {
            [predString appendString:@" OR "];
        }
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predString];
    return [query matchingPredicate:predicate];
}
@end


#import "QuerySpecifierByText.h"

@implementation QuerySpecifierByText
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

     JJM: I tried NSCompoundPredicate and I consistently got no results.  My best
     guess is that XCUIElementQuery does not respond to compound predicates.

     We could try NSPredicate predicateWithBlock:, but my guess is that this will
     not work.

     Recall that CoreData does not allow block predicates, so there is some
     precedence for restricting NSPredicate kinds (?) in certain contexts.

     NOTE: Using == here is appropriate.  LIKE responds to the ? character which
     will be a problem if the value contains a ?.
     */

    NSString *escaped = [QuerySpecifier escapeString:self.value];
    NSMutableString *predString = [NSMutableString string];
    for (NSString *prop in textProperties) {
        [predString appendFormat:@"%@ == '%@'", prop, escaped];
        if (prop != [textProperties lastObject]) {
            [predString appendString:@" OR "];
        }
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predString];
    return [query matchingPredicate:predicate];
}

@end

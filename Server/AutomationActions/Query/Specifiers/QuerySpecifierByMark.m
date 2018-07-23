
#import "QuerySpecifierByMark.h"
#import "XCTest+CBXAdditions.h"
#import "CBX-XCTest-Umbrella.h"

@implementation QuerySpecifierByMark

static NSArray<NSString *> *markedProperties;

+ (void)load {
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        markedProperties = @[
                             @"identifier",
                             @"accessibilityIdentifier",
                             @"label",
                             @"accessibilityLabel",
                             @"title",
                             @"value",
                             @"placeholderValue"
                             ];
    });
}

+ (NSString *)name { return @"marked"; }

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
    NSMutableString *predicateString = [NSMutableString string];
    for (NSString *prop in markedProperties) {
        [predicateString appendFormat:@"%@ == '%@'", prop, escaped];
        if (prop != [markedProperties lastObject]) {
            [predicateString appendString:@" OR "];
        }
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    return [query matchingPredicate:predicate];
}

@end

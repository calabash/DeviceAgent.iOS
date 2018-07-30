
#import "QuerySpecifierByTextLike.h"
#import "XCTest+CBXAdditions.h"
#import "CBX-XCTest-Umbrella.h"

@implementation QuerySpecifierByTextLike

+ (NSString *)name { return @"text_like"; }

- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query {
    NSMutableString *predString = [NSMutableString string];
    for (NSString *prop in [QuerySpecifierByText textProperties]) {
        [predString appendFormat:@"%@ LIKE[cd] '*%@*'", prop, self.value];
        if (prop != [[QuerySpecifierByText textProperties] lastObject]) {
            [predString appendString:@" OR "];
        }
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predString];
    return [query matchingPredicate:predicate];
}
@end

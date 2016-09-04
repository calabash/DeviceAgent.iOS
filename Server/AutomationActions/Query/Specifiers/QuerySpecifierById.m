
#import "QuerySpecifierById.h"

@implementation QuerySpecifierById

+ (NSString *)name { return @"id"; }

- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query {
    NSString *escaped = [QuerySpecifier escapeString:self.value];
    return [query matchingIdentifier:escaped];
}

@end

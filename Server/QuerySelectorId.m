
#import "QuerySelectorId.h"

@implementation QuerySelectorId

+ (NSString *)name { return @"id"; }

- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query {
    return [query matchingIdentifier:self.value];
}
@end

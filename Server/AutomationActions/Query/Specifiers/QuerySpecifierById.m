
#import "QuerySpecifierById.h"

@implementation QuerySpecifierById

+ (NSString *)name { return @"id"; }

- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query {
    return [query matchingIdentifier:self.value];
}
@end

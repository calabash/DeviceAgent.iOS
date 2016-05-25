

#import "QuerySpecifierByType.h"
#import "JSONUtils.h"

@implementation QuerySpecifierByType
+ (NSString *)name { return @"type"; }

- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query {
    return [query descendantsMatchingType:[JSONUtils elementTypeForString:self.value]];
}
@end

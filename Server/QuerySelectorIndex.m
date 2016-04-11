
#import "QuerySelectorIndex.h"

@implementation QuerySelectorIndex

+ (QuerySelectorExecutionPriority)executionPriority {
    return kQuerySelectorExecutionPriorityLast;
}

+ (NSString *)name { return @"index"; }

- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query {
    return [query elementBoundByIndex:[self.value integerValue] /* returns an XCUIElement */ ].query;
}
@end

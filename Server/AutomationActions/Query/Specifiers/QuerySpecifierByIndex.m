
#import "QuerySpecifierByIndex.h"

@implementation QuerySpecifierByIndex

+ (QuerySpecifierExecutionPriority)executionPriority {
    return kQuerySpecifierExecutionPriorityLast;
}

+ (NSString *)name { return @"index"; }

- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query {
    return [query elementBoundByIndex:[self.value integerValue] /* returns an XCUIElement */ ].query;
}
@end


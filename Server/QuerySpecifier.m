
#import <XCTest/XCUIElementQuery.h>
#import "XCUIApplication.h"
#import "Application.h"
#import "QuerySpecifier.h"

@implementation QuerySpecifier

+ (QuerySpecifierExecutionPriority)executionPriority {
    return kQuerySpecifierExecutionPriorityAny;
}

+ (NSString *)name { return nil; }

+ (instancetype)withValue:(id)value {
    QuerySpecifier *qs = [self new];
    qs.value = value;
    return qs;
}

- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query {
    _must_override_exception;
}
- (XCUIElementQuery *)applyToQuery:(XCUIElementQuery *)query {
    if (query == nil) {
        XCUIElementQuery *all = [[Application currentApplication].query descendantsMatchingType:XCUIElementTypeAny];
        return [self applyInternal:all];
    } else {
        return [self applyInternal:query];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ = %@", [self.class name], self.value];
}
@end


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
    return [self applyInternal:query];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ = %@", [self.class name], self.value];
}
@end

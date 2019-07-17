
#import "XCTest+CBXAdditions.h"
#import "CBX-XCTest-Umbrella.h"
#import "CBXException.h"

// This implementation does not implement all the methods in the category
// interface.  This is by design - the category is used to expose private
// methods.  It is safe to ignore these warnings.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation XCUIApplication (CBXAdditions)

+ (NSString *_Nonnull)cbxStringForApplicationState:(XCUIApplicationState)state {
    switch (state) {
        case XCUIApplicationStateUnknown: { return @"unknown"; }
        case XCUIApplicationStateNotRunning: { return @"not running"; }
        case XCUIApplicationStateRunningBackgroundSuspended: {
            return @"background suspended";
        }
        case XCUIApplicationStateRunningBackground: { return @"background"; }
        case XCUIApplicationStateRunningForeground: { return @"foreground"; }
        default: {
            @throw [CBXException withFormat:@"Cannot find string for "
                    "application state: %@", @(state)];
        }
    }
}

+ (id _Nullable)cbxQuery:(XCUIApplication *)xcuiApplication {
    SEL selector = NSSelectorFromString(@"query");

    NSMethodSignature *signature;
    Class klass = NSClassFromString(@"XCUIApplication");
    signature = [klass instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation;

    invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = xcuiApplication;
    invocation.selector = selector;

    id query = nil;
    void *buffer = nil;
    [invocation invoke];
    [invocation getReturnValue:&buffer];
    query = (__bridge id)buffer;
    return query;
}

+ (void)cbxResolveApplication:(XCUIApplication *_Nonnull)xcuiApplication {
    id applicationQuery = [XCUIApplication cbxQuery:xcuiApplication];
    [XCUIApplication cbxResolveApplication:xcuiApplication
                          applicationQuery:applicationQuery];
}

+ (void)cbxResolveApplication:(XCUIApplication *_Nonnull)xcuiApplication
             applicationQuery:(XCApplicationQuery *_Nonnull)applicationQuery {

    Class klass = NSClassFromString(@"XCApplicationQuery");
    SEL selector = NSSelectorFromString(@"elementBoundByIndex:");

    NSMethodSignature *signature;
    signature = [klass instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation;

    invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = applicationQuery;
    invocation.selector = selector;
    NSUInteger index = 0;
    [invocation setArgument:&index atIndex:2];

    XCUIElement *element = nil;
    void *buffer = nil;
    [invocation invoke];
    [invocation getReturnValue:&buffer];
    element = (__bridge XCUIElement *)buffer;

    if ([element respondsToSelector:@selector(resolve)]) {
        [element resolve];
    } else {
        [element resolveOrRaiseTestFailure];
    }
}

- (XCElementSnapshot *_Nullable)cbxXCElementSnapshot {
    id applicationQuery = [XCUIApplication cbxQuery:self];

    Class klass = NSClassFromString(@"XCApplicationQuery");
    SEL selectorUpdated = NSSelectorFromString(@"elementSnapshotForDebugDescriptionWithNoMatchesMessage:");
    SEL selectorLegacy = NSSelectorFromString(@"elementSnapshotForDebugDescription"); // before Xcode 11
    SEL validSelector;
    NSMethodSignature *signature = [klass instanceMethodSignatureForSelector:selectorUpdated];
    if (signature != nil) {
        validSelector = selectorUpdated;
    } else {
        signature = [klass instanceMethodSignatureForSelector:selectorLegacy];
        validSelector = selectorLegacy;
    }
    
    NSInvocation *invocation;
    invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = applicationQuery;
    invocation.selector = validSelector;

    XCElementSnapshot *snapshot = nil;
    void *buffer = nil;
    [invocation invoke];
    [invocation getReturnValue:&buffer];
    snapshot = (__bridge XCElementSnapshot *)buffer;
    return snapshot;
}

- (XCUIElementQuery *_Nonnull)cbxQueryForDescendantsOfAnyType {
    id applicationQuery = [XCUIApplication cbxQuery:self];

    [XCUIApplication cbxResolveApplication:self
                          applicationQuery:applicationQuery];

    Class klass = NSClassFromString(@"XCApplicationQuery");
    SEL selector = NSSelectorFromString(@"descendantsMatchingType:");

    NSMethodSignature *signature;
    signature = [klass instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation;

    invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = applicationQuery;
    invocation.selector = selector;

    XCUIElementType elementType = XCUIElementTypeAny;
    [invocation setArgument:&elementType atIndex:2];

    XCUIElementQuery *query = nil;
    void *buffer = nil;
    [invocation invoke];
    [invocation getReturnValue:&buffer];
    query = (__bridge XCUIElementQuery *)buffer;
    return query;
}

@end
#pragma clang diagnostic pop

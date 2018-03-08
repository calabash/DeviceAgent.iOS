
#import "XCTest+CBXAdditions.h"
#import "CBX-XCTest-Umbrella.h"
#import "CBXConstants.h"
#import "CBXMachClock.h"

@implementation XCUIApplication (CBXAddtions)

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

    [element resolve];
}

- (XCElementSnapshot *_Nullable)cbxXCElementSnapshot {
    id applicationQuery = [XCUIApplication cbxQuery:self];

    Class klass = NSClassFromString(@"XCApplicationQuery");
    SEL selector = NSSelectorFromString(@"elementSnapshotForDebugDescription");

    NSMethodSignature *signature;
    signature = [klass instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation;

    invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = applicationQuery;
    invocation.selector = selector;

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

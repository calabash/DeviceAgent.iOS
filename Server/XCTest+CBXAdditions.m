
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

    [element cbx_resolve];
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

@implementation XCUIElement (CBXAdditions)
- (void)cbx_resolve {
    if ([self respondsToSelector:@selector(resolve)]) {
        [self resolve];
    } else {
        NSError *error = nil;
        if (![self resolveOrRaiseTestFailure:NO error:&error]) {
            DDLogWarn(@"Encountered an error resolving element '%@':\n%@",
                    self, [error localizedDescription]);
        }
    }
}
@end

@implementation XCUIElementQuery (CBXAdditions)

- (XCElementSnapshot *)cbx_elementSnapshotForDebugDescription {
  if ([self respondsToSelector:@selector(elementSnapshotForDebugDescription)]) {
    return [self elementSnapshotForDebugDescription];
  }
  if ([self respondsToSelector:@selector(elementSnapshotForDebugDescriptionWithNoMatchesMessage:)]) {
    return [self elementSnapshotForDebugDescriptionWithNoMatchesMessage:nil];
  }
  @throw [CBXException withFormat:@"Cannot retrieve element snapshot"];
  return nil;
}

@end

#pragma clang diagnostic pop

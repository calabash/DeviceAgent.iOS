
#import "XCTest+CBXAdditions.h"
#import "CBX-XCTest-Umbrella.h"
#import "CBXConstants.h"
#import "CBXMachClock.h"

@implementation XCUIApplication (CBXAddtions)

+ (id)cbxApplicationQuery:(XCUIApplication *)xcuiApplication {
    SEL selector = NSSelectorFromString(@"applicationQuery");

    NSMethodSignature *signature;
    Class klass = NSClassFromString(@"XCUIApplication");
    signature = [klass instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation;

    invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = xcuiApplication;
    invocation.selector = selector;

    id applicationQuery = nil;
    void *buffer;
    [invocation invoke];
    [invocation getReturnValue:&buffer];
    applicationQuery = (__bridge id)buffer;
    return applicationQuery;
}

+ (void)cbxResolveApplication:(XCUIApplication *_Nonnull)xcuiApplication {
    NSTimeInterval start = [[CBXMachClock sharedClock] absoluteTime];

    id applicationQuery = [XCUIApplication cbxApplicationQuery:xcuiApplication];

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
    void *buffer;
    [invocation invoke];
    [invocation getReturnValue:&buffer];
    element = (__bridge XCUIElement *)buffer;

    [element resolve];

    NSTimeInterval end = [[CBXMachClock sharedClock] absoluteTime];
    NSTimeInterval elapsed = end - start;
    DDLogDebug(@"Took %@ seconds to resolve application snapshot", @(elapsed));
}

@end

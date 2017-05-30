
#import "CBLSApplicationProxy.h"
#import "CBLSApplicationWorkspace.h"

@interface CBLSApplicationProxy ()

@property(strong, readonly) id applicationProxy;

- (instancetype)initWithApplicationProxy:(id)applicationProxy;

@end

@implementation CBLSApplicationProxy

- (instancetype)initWithApplicationProxy:(id)applicationProxy {
    self = [super init];
    if (self) {
        _applicationProxy = applicationProxy;
    }

    return self;
}

+ (CBLSApplicationProxy *)applicationProxyForIdentifier:(NSString *)bundleIdentifier {

    // LSApplicationProxy#applicationProxyForIdentifier always returns a non-nil instance.
    if (![CBLSApplicationWorkspace applicationIsInstalled:bundleIdentifier]) {
        return nil;
    }

    Class klass = NSClassFromString(@"LSApplicationProxy");
    SEL selector = NSSelectorFromString(@"applicationProxyForIdentifier:");

    NSMethodSignature *signature;
    signature = [klass methodSignatureForSelector:selector];
    NSInvocation *invocation;

    invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = klass;
    invocation.selector = selector;

    NSString *localCopy = [bundleIdentifier copy];
    [invocation setArgument:&localCopy atIndex:2];

    id applicationProxy = nil;
    void *buffer;
    [invocation invoke];
    [invocation getReturnValue:&buffer];
    applicationProxy = (__bridge id)buffer;

    if (applicationProxy) {
        return [[CBLSApplicationProxy alloc] initWithApplicationProxy:applicationProxy];
    } else {
        return nil;
    }
}

- (NSString *)localizedName {
    if (!self.applicationProxy) { return nil; }

    SEL selector = NSSelectorFromString(@"localizedName");
    NSMethodSignature *signature;
    Class klass = NSClassFromString(@"LSApplicationProxy");
    signature = [klass instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation;

    invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self.applicationProxy;
    invocation.selector = selector;

    NSString *localizedName = nil;
    void *buffer;
    [invocation invoke];
    [invocation getReturnValue:&buffer];
    localizedName = (__bridge NSString *)buffer;

    return localizedName;
}

- (NSURL *)bundleURL {
    return [self.applicationProxy performSelector:@selector(bundleURL)];
}

@end

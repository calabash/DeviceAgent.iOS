
#import "QuerySpecifierFactory.h"
#import <objc/runtime.h>

@implementation QuerySpecifierFactory
static NSMutableDictionary <NSString *, Class> *selectorClasses;
+ (void)load {
    unsigned int outCount;
    Class *classes = objc_copyClassList(&outCount);
    selectorClasses = [NSMutableDictionary dictionaryWithCapacity:outCount];
    for (int i = 0; i < outCount; i++) {
        Class c = classes[i];
        if (class_conformsToProtocol(c, @protocol(QuerySpecifier))) {
            if ([c name]) {
                selectorClasses[[c name]] = c;
                NSLog(@"Registered support for selector: %@", [c name]);
            }
        }
    }
    free(classes);
}

+ (NSArray <NSString *> *)supportedSpecifierNames {
    return [selectorClasses allKeys];
}

+ (QuerySpecifier *)specifierWithKey:(NSString *)key value:(id)val {
    Class<QuerySpecifier> c = selectorClasses[key];
    if (!c) {
        @throw [InvalidArgumentException withMessage:@"Invalid key for query selector"
                                            userInfo:@{@"key" : key ?: [NSNull null],
                                                       @"Supported Keys" : [self supportedSpecifierNames]
                                                       }];
    }
    return [c withValue:val];
}
@end

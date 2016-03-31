//
//  QuerySelectorFactory.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/22/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "QuerySelectorFactory.h"
#import <objc/runtime.h>

@implementation QuerySelectorFactory
static NSMutableDictionary <NSString *, Class> *selectorClasses;
+ (void)load {
    unsigned int outCount;
    Class *classes = objc_copyClassList(&outCount);
    selectorClasses = [NSMutableDictionary dictionaryWithCapacity:outCount];
    for (int i = 0; i < outCount; i++) {
        Class c = classes[i];
        if (class_conformsToProtocol(c, @protocol(QuerySelector))) {
            if ([c name]) {
                selectorClasses[[c name]] = c;
            }
        }
    }
    free(classes);
}

+ (QuerySelector *)selectorWithKey:(NSString *)key value:(id)val {
    Class<QuerySelector> c = selectorClasses[key];
    return [c withValue:val];
}
@end

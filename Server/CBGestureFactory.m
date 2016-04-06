//
//  CBGestureFactory.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/18/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBInvalidArgumentException.h"
#import "CBGestureFactory.h"
#import <objc/runtime.h>

@implementation CBGestureFactory
static NSMutableSet <Class> *gestureClasses;

/*
 * Obtain all gesture classes
 */
+ (void)load {
    gestureClasses = [NSMutableSet set];
    unsigned int outCount;
    Class *classes = objc_copyClassList(&outCount);
    for (int i = 0; i < outCount; i++) {
        Class c = classes[i];
        if (c != [CBGesture class] && class_conformsToProtocol(c, @protocol(CBGesture))) {
            NSLog(@"Registered %@ gesture", [c name]);
            [gestureClasses addObject:c];
        }
    }
    free(classes);
}

+ (CBGesture *)executeGestureWithJSON:(NSDictionary *)json completion:(CompletionBlock)completion {
    NSString *gesture = json[@"gesture"];
    if (!gesture) {
        @throw [CBInvalidArgumentException withMessage:@"Invalid gesture: missing 'gesture' key."];
    }

    for (Class <CBGesture> c in gestureClasses) {
        if (c != [CBGesture class] && [gesture isEqualToString:[c name]]) {
            GestureConfiguration *gestureConfig = [GestureConfiguration withJSON:json[CB_OPTIONS_KEY]
                                                                       validator:[c validator]];
            QueryConfiguration *queryConfig = [QueryConfiguration withJSON:json[CB_SPECIFIERS_KEY]
                                                                 validator:[CBQuery validator]];
            CBQuery *query = [CBQuery withQueryConfiguration:queryConfig];
            return [c executeWithGestureConfiguration:gestureConfig
                                                query:query
                                           completion:completion];
        }
    }
    
    @throw [CBInvalidArgumentException withMessage:
            [NSString stringWithFormat:
             @"Invalid gesture: No matching gesture for '%@' with specifiers: %@", gesture, json]];
}
@end

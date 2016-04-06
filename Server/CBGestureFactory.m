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

+ (void)validateGestureRequestFormat:(NSDictionary *)json {
    NSArray *requiredKeys = @[CB_GESTURE_KEY, CB_SPECIFIERS_KEY, CB_OPTIONS_KEY];
    JSONKeyValidator *validator = [JSONKeyValidator withRequiredKeys:requiredKeys
                                                        optionalKeys:@[]];
    [validator validate:json];
}

+ (CBGesture *)executeGestureWithJSON:(NSDictionary *)json completion:(CompletionBlock)completion {
    [self validateGestureRequestFormat:json];
    
    NSString *gesture = json[CB_GESTURE_KEY];
    NSDictionary *options = json[CB_OPTIONS_KEY];
    NSDictionary *specifiers = json[CB_SPECIFIERS_KEY];

    for (Class <CBGesture> c in gestureClasses) {
        if (c != [CBGesture class] && [gesture isEqualToString:[c name]]) {
            
            GestureConfiguration *gestureConfig = [GestureConfiguration withJSON:options
                                                                       validator:[c validator]];
            QueryConfiguration *queryConfig = [QueryConfiguration withJSON:specifiers
                                                                 validator:[CBQuery validator]];
            CBQuery *query = [CBQuery withQueryConfiguration:queryConfig];
            return [c executeWithGestureConfiguration:gestureConfig
                                                query:query
                                           completion:completion];
        }
    }
    
    @throw [CBInvalidArgumentException withMessage:
            [NSString stringWithFormat:
             @"Invalid gesture: No matching gesture for '%@'",
             gesture]];
}
@end

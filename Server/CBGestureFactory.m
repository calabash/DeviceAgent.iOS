
#import "InvalidArgumentException.h"
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
        if (c != [Gesture class] && class_conformsToProtocol(c, @protocol(Gesture))) {
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

+ (Gesture *)executeGestureWithJSON:(NSDictionary *)json completion:(CompletionBlock)completion {
    [self validateGestureRequestFormat:json];
    
    NSString *gesture = json[CB_GESTURE_KEY];
    NSDictionary *options = json[CB_OPTIONS_KEY];       // => gesture
    NSDictionary *specifiers = json[CB_SPECIFIERS_KEY]; // => queries

    for (Class <Gesture> c in gestureClasses) {
        if (c != [Gesture class] && [gesture isEqualToString:[c name]]) {
            GestureConfiguration *gestureConfig = [GestureConfiguration withJSON:options
                                                                       validator:[c validator]];
            QueryConfiguration *queryConfig = [QueryConfiguration withJSON:specifiers
                                                                 validator:[Query validator]];
            Query *query = [Query withQueryConfiguration:queryConfig];
            return [c executeWithGestureConfiguration:gestureConfig
                                                query:query
                                           completion:completion];
        }
    }
    
    @throw [InvalidArgumentException withMessage:
            [NSString stringWithFormat:
             @"Invalid gesture: No matching gesture for '%@'",
             gesture]];
}
@end

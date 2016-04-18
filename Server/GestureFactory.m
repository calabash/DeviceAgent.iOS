
#import "InvalidArgumentException.h"
#import "GestureFactory.h"
#import <objc/runtime.h>

@implementation GestureFactory
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
    NSArray *requiredKeys = @[CBX_GESTURE_KEY];
    JSONKeyValidator *validator = [JSONKeyValidator withRequiredKeys:requiredKeys
                                                        optionalKeys:@[CBX_OPTIONS_KEY, CBX_SPECIFIERS_KEY]];
    [validator validate:json];
}

+ (Gesture *)executeGestureWithJSON:(NSDictionary *)json completion:(CompletionBlock)completion {
    [self validateGestureRequestFormat:json];
    
    NSString *gesture = json[CBX_GESTURE_KEY];
    NSDictionary *options = json[CBX_OPTIONS_KEY];       // => gesture
    NSDictionary *specifiers = json[CBX_SPECIFIERS_KEY]; // => queries

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

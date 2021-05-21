
#import "InvalidArgumentException.h"
#import "Testmanagerd.h"
#import "ThreadUtils.h"
#import "EnterText.h"
#import "CBXConstants.h"
#import "GestureConfiguration.h"

@implementation EnterText

+ (NSString *)name { return @"enter_text"; }

+ (NSArray <NSString *> *)requiredKeys {
    return @[ CBX_STRING_KEY ];
}

+ (NSArray <NSString *> *)optionalKeys {
    return @[];
}

// Callers are responsible for checking that a keyboard is visible.
+ (Gesture *)executeWithGestureConfiguration:(GestureConfiguration *)gestureConfig
                                       query:(Query *)query
                                  completion:(CompletionBlock)completion {
    if (![gestureConfig has:CBX_STRING_KEY]) {
        @throw [InvalidArgumentException withFormat:@"Missing required key 'string'"];
    }

    NSString *string = gestureConfig[CBX_STRING_KEY];

    __block NSError *outerError = nil;
    [ThreadUtils runSync:^(BOOL *setToTrueWhenDone) {
        [[Testmanagerd_EventSynthesis get]
         _XCT_sendString:string
         maximumFrequency:CBX_DEFAULT_SEND_STRING_FREQUENCY
         completion:^(NSError *innerError) {
             outerError = innerError;
             if (innerError) {
                 DDLogError(@"Encountered error typing text: %@", innerError);
             }
             *setToTrueWhenDone = YES;
         }];
    }];

    completion(outerError);
    return nil;
}

@end

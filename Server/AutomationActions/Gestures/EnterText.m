
#import "InvalidArgumentException.h"
#import "Testmanagerd.h"
#import "ThreadUtils.h"
#import "EnterText.h"
#import "Application.h"

@implementation EnterText

+ (NSString *)name { return @"enter_text"; }

+ (NSArray <NSString *> *)requiredKeys {
    return @[ CBX_STRING_KEY ];
}

+ (NSArray <NSString *> *)optionalKeys {
    return @[];
}

+ (Gesture *)executeWithGestureConfiguration:(GestureConfiguration *)gestureConfig
                                       query:(Query *)query
                                  completion:(CompletionBlock)completion {
    if (![gestureConfig has:CBX_STRING_KEY]) {
        @throw [InvalidArgumentException withFormat:@"Missing required key 'string'"];
    }

    NSString *string = gestureConfig[CBX_STRING_KEY];

    __block NSError *outerError = nil;
    [ThreadUtils runSync:^(BOOL *setToTrueWhenDone) {
        [[Testmanagerd get] _XCT_sendString:string
                           maximumFrequency:CBX_DEFAULT_SEND_STRING_FREQUENCY
                                 completion:^(NSError *innerError) {
                                     outerError = innerError;
                                     *setToTrueWhenDone = YES;
                                     if (innerError) {
                                         @throw [CBXException withMessage:@"Error performing gesture"];
                                     }
                                 }];
    }];
    
    completion(outerError);
    return nil;
}

@end

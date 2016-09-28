
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

// Original implementation - not working on iOS 10 physical devices
// https://xamarin.atlassian.net/browse/TCFW-333
//
//    [ThreadUtils runSync:^(BOOL *setToTrueWhenDone, NSError *__autoreleasing *err) {
//        [[Testmanagerd get] _XCT_sendString:string
//         maximumFrequency:CBX_DEFAULT_SEND_STRING_FREQUENCY
//                                 completion:^(NSError *e) {
//            *err = e;
//            *setToTrueWhenDone = YES;
//        }];
//    } completion:completion];

    // This is working on iOS 9 - 10 sims and physical devices.
    XCUIApplication *application = [Application currentApplication];
    if ([application lastSnapshot] == nil) {
        [[application applicationQuery] elementBoundByIndex:0];
        [application resolve];
    }

    [application typeText:string];

    completion(nil);
    return nil;
}

@end

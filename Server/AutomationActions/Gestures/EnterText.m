
#import "InvalidArgumentException.h"
#import "Testmanagerd.h"
#import "ThreadUtils.h"
#import "EnterText.h"
#import "CBXDevice.h"
#import "TextInputFirstResponderProvider.h"

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
    if ([[CBXDevice sharedDevice] isArm64]) {
        NSLog(@"Device has arm64 architecture: %@", [[CBXDevice sharedDevice] armVersion]);
        [ThreadUtils runSync:^(BOOL *setToTrueWhenDone) {
            [[Testmanagerd get]
             _XCT_sendString:string
             maximumFrequency:CBX_DEFAULT_SEND_STRING_FREQUENCY
             completion:^(NSError *innerError) {
                 outerError = innerError;
                 *setToTrueWhenDone = YES;
                 NSString *message;
                 message = [NSString stringWithFormat:@"Encountered an error typing text: %@",
                            innerError];
                 if (innerError) {
                     @throw [CBXException withMessage:message];
                 }
             }];
        }];
    } else {
        NSLog(@"Device does not have arm64 architecture: %@",
              [[CBXDevice sharedDevice] armVersion]);
        // Gestures need to be automatic - a gesture must complete before the next
        // gesture started.  Depending on the internal implementation of typeText:,
        // this should block other gestures.
        @synchronized([Testmanagerd get]) {
            TextInputFirstResponderProvider *provider = [TextInputFirstResponderProvider new];
            XCUIElement *firstResponder = [provider firstResponderOrApplication];
            [firstResponder typeText:string];
        }
    }

    completion(outerError);
    return nil;
}

@end

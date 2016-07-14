

#import "ClearText.h"
#import "ThreadUtils.h"

@implementation ClearText

+ (NSString *)name { return @"clear_text"; }
+ (NSArray <NSString *> *)optionalKeys { return @[]; }
+ (NSArray <NSString *> *)requiredKeys { return @[]; }

+ (Gesture *)executeWithGestureConfiguration:(GestureConfiguration *)gestureConfig
                                       query:(Query *)query
                                  completion:(CompletionBlock)completion {

    QueryConfiguration *config = [QueryConfiguration withJSON:@{
                                                                @"property" : @"hasKeyboardFocus=YES"
                                                                }
                                                    validator:nil];
    Query *focusedElementQuery = [Query withQueryConfiguration:config];
    NSArray *results = [focusedElementQuery execute];
    if (results.count == 0) {
        @throw [CBXException withMessage:@"Can not clear text: no element has focus"];
    } else if (results.count > 1) {
        @throw [CBXException withMessage:@"Refusing to clear text: multiple elements have focus"];
    }
    XCUIElement *el = results[0];

    [ThreadUtils runSync:^(BOOL *setToTrueWhenDone, NSError *__autoreleasing *err) {
        NSString *string = el.value;
        NSMutableString *delString = [NSMutableString new];
        for (int i = 0; i < string.length; i++) {
            [delString appendString:@"\b"];
        }
        [el typeText:delString];

        [[Testmanagerd get] _XCT_sendString:string
                           maximumFrequency:CBX_DEFAULT_SEND_STRING_FREQUENCY
                                 completion:^(NSError *e) {
                                     *err = e;
                                     *setToTrueWhenDone = YES;
                                 }];
    } completion:completion];
    
    return nil;
}

@end

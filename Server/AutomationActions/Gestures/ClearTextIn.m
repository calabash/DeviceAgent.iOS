#import "ThreadUtils.h"
#import "ClearTextIn.h"
#import "Touch.h"

@implementation ClearTextIn
+ (NSString *)name { return @"clear_text_in"; }
+ (NSArray <NSString *> *)optionalKeys { return @[]; }
+ (NSArray <NSString *> *)requiredKeys { return @[]; }

+ (Gesture *)executeWithGestureConfiguration:(GestureConfiguration *)gestureConfig
                                       query:(Query *)query
                                  completion:(CompletionBlock)completion {

    NSArray<XCUIElement *> *els = [query execute];
    if (els.count == 0) {
        @throw [CBXException withMessage:@"Can not clear text: no element found."
                                userInfo:@{@"query" : query.toJSONString}];
    }
    XCUIElement *el = els[0];
    if (![el respondsToSelector:@selector(value)]) {
        @throw [CBXException withMessage:@"Can not clear text: Element does not have a 'value'"
                                userInfo:[JSONUtils elementToJSON:el]];
    }

    __block NSError *err;
    [ThreadUtils runSync:^(BOOL *setToTrueWhenDone) {
        NSString *string = el.value;
        NSMutableString *delString = [NSMutableString new];
        for (int i = 0; i < string.length; i++) {
            [delString appendString:@"\b"];
        }
        [el typeText:delString];

        [[Testmanagerd get] _XCT_sendString:string
                           maximumFrequency:CBX_DEFAULT_SEND_STRING_FREQUENCY
                                 completion:^(NSError *e) {
                                     err = e;
                                     *setToTrueWhenDone = YES;
                                 }];
    }];
    
    completion(err);
    return nil;
}

@end

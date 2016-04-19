
#import "EnterTextIn.h"
#import "ThreadUtils.h"
#import "JSONUtils.h"
#import "Touch.h"

@implementation EnterTextIn
+ (NSString *)name { return @"enter_text_in"; }

+ (NSArray <NSString *> *)requiredKeys {
    return @[@"string"];
}

+ (NSArray <NSString *> *)optionalKeys {
    return @[];
}

+ (Gesture *)executeWithGestureConfiguration:(GestureConfiguration *)gestureConfig
                                         query:(Query *)query
                                    completion:(CompletionBlock)completion {
    
    NSString *string = gestureConfig[CBX_STRING_KEY];
    if (!string) {
        @throw [InvalidArgumentException withFormat:@"Missing required key 'string'"];
    }
    
    Touch *touch = [Touch withGestureConfiguration:gestureConfig query:query];
    

    [touch execute:^(NSError *e) {
        if (e) {
            completion(e);
        } else {
            [ThreadUtils runSync:^(BOOL *setToTrueWhenDone, NSError *__autoreleasing *err) {
                [[Testmanagerd get] _XCT_sendString:string completion:^(NSError *e) {
                    if (e) @throw [CBXException withMessage:@"Error performing gesture"];
                    *setToTrueWhenDone = YES;
                    *err = e;
                }];
            } completion:completion];
        }
    }];
    
    return touch;
}
@end


#import "EnterTextIn.h"
#import "JSONUtils.h"
#import "Touch.h"

@implementation EnterTextIn
+ (NSString *)name { return @"enter_text_in"; }

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
            [[Testmanagerd get] _XCT_sendString:string completion:^(NSError *e) {
                if (e) @throw [CBXException withMessage:@"Error performing gesture"];
            }];
            completion(e);
        }
    }];
    
    return touch;
}
@end



#import "ClearText.h"
#import "ThreadUtils.h"

@implementation ClearText

+ (NSString *)name { return @"clear_text"; }
+ (NSArray <NSString *> *)optionalKeys { return @[]; }
+ (NSArray <NSString *> *)requiredKeys { return @[]; }

+ (Gesture *)executeWithGestureConfiguration:(GestureConfiguration *)gestureConfig
                                       query:(Query *)query
                                  completion:(CompletionBlock)completion {

    QueryConfiguration *config =
    [QueryConfiguration withJSON:@{
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

    XCUIElement *elementWithFocus = results[0];
    NSString *string = elementWithFocus.value;

    if (!string || [string length] == 0) {
        completion(nil);
        return nil;
    } else {
        for (NSUInteger index = 0; index < [string length]; index++) {
          // touch the delete key
          // In the run-loop client I use `marked:'delete'`
          // Is there an advantage of tapping the XCUIElement with QueryConfig @"marked": @"delete"?
          // In theory having to execute both queries makes the tapping approach slightly slower ~14s compared to ~11s
          // when using type text
          [elementWithFocus typeText:@"\b"];
        }
        completion(nil);
        return nil;
    }
}

@end

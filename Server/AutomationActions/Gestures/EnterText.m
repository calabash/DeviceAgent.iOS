
#import "InvalidArgumentException.h"
#import "Testmanagerd.h"
#import "ThreadUtils.h"
#import "EnterText.h"
#import "Application.h"

@interface EnterText ()

@end

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

    @synchronized (self) {

        NSString *string = gestureConfig[CBX_STRING_KEY];

        XCUIApplication *application = [Application currentApplication];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@",
                                  @"hasKeyboardFocus",
                                  @(YES)];

        XCUIElement *firstResponder = nil;

        // This is an optimization.  Querying all elements is for the one with keyboard focus
        // can be prohibitively expensive (tens of seconds).
        NSArray<NSNumber *> *types = @[@(XCUIElementTypeTextField),
                                       @(XCUIElementTypeTextView),
                                       @(XCUIElementTypeSecureTextField),
                                       @(XCUIElementTypeOther)];
        for (NSNumber *number in types) {
            NSUInteger type = [number unsignedIntegerValue];
            XCUIElementQuery *firstResponderQuery = [application descendantsMatchingType:type];
            XCUIElementQuery *matching = [firstResponderQuery matchingPredicate:predicate];
            NSArray <XCUIElement *> *elements = [matching allElementsBoundByIndex];
            if ([elements count] == 1) {
                firstResponder = elements[0];
                NSLog(@"Element with keyboard focus has type %@", [JSONUtils stringForElementType:type]);
                break;
            }
        }

        if (!firstResponder) {
            NSLog(@"Could not find an element with keyboard focus; will use the XCUIApplication#typeText");

            // This seems to work in most cases.  However, we've observed problems:
            // * typing text is very slow (characters per hour)
            // * this error message is emitted:
            //   Xcode UI Testing fails to type text: Neither element nor any descendant has keyboard focus
            firstResponder = application;
        }

        [firstResponder typeText:string];

        completion(nil);
        return nil;
    }
}

@end

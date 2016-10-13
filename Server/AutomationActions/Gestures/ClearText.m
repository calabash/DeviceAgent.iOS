
#import "ClearText.h"

@interface ClearText ()

@property(strong, readonly) NSPredicate *deleteKeyPredicate;

+ (ClearText *)shared;
- (XCUIElement *)deleteKey;

@end

@implementation ClearText

@synthesize deleteKeyPredicate = _deleteKeyPredicate;

+ (ClearText *)shared {
    static ClearText *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ClearText alloc] init];
    });
    return instance;
}

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
        XCUIElement *deleteKey = [[ClearText shared] deleteKey];
        [deleteKey resolve];

        if (deleteKey == nil || !deleteKey.exists) {
            for (NSUInteger index = 0; index < [string length]; index++) {
                [elementWithFocus typeText:@"\b"];
            }
        } else {
            for (NSUInteger index = 0; index < [string length]; index++) {
               [deleteKey tap];
            }
        }

        completion(nil);
        return nil;
    }
}

- (NSPredicate *)deleteKeyPredicate {
    if (_deleteKeyPredicate) { return _deleteKeyPredicate; }
    NSMutableString *predicateString = [NSMutableString string];
    NSArray *properties = @[@"identifier", @"accessibilityIdentifier",
                            @"label", @"accessibilityLabel"];
    for (NSString *property in properties) {
        [predicateString appendFormat:@"%@ == 'delete'", property];
        [predicateString appendString:@" OR "];
        [predicateString appendFormat:@"%@ == 'Delete'", property];
        if (property != [properties lastObject]) {
            [predicateString appendString:@" OR "];
        }
    }
    _deleteKeyPredicate = [NSPredicate predicateWithFormat:predicateString];
    return _deleteKeyPredicate;
}

- (XCUIElement *)deleteKey {
    XCUIApplication *application = [Application currentApplication];
    XCUIElementQuery *query = [application descendantsMatchingType:XCUIElementTypeKey];
    XCUIElementQuery *matching = [query matchingPredicate:[self deleteKeyPredicate]];
    NSArray <XCUIElement *> *elements = [matching allElementsBoundByIndex];
    if ([elements count] == 1) {
        NSLog(@"Expected 1 element to match type 'Key' and id 'delete', found none");
       return nil;
    } else if ([elements count] == nil) {
        return nil;
    } else if ([elements count] != 1) {
        NSLog(@"Expected 1 element to match type 'Key' and id 'delete', found %@",
              @([elements count]));
        return elements[0];
    } else {
        return elements[0];
    }
}
@end

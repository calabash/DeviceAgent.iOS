
#import "ClearText.h"
#import "TextInputFirstResponderProvider.h"
#import "Testmanagerd.h"
#import "ThreadUtils.h"
#import "CBXDevice.h"
#import "XCUIElement.h"
#import "XCElementSnapshot.h"
#import "XCUIElement+WebDriverAttributes.h"
#import "GestureFactory.h"

@interface ClearText ()

@property(strong, readonly) NSPredicate *deleteKeyPredicate;

+ (ClearText *)shared;
- (XCUIElement *)deleteKey;
- (XCUIElement *)firstResponder;

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

    XCUIElement *firstResponder = [[ClearText shared] firstResponder];

    if (!firstResponder) {
        @throw [CBXException withMessage:@"Can not clear text: no element has focus"];
    }

    NSString *string = firstResponder.value;

    if (!string || [string length] == 0) {
        completion(nil);
        return nil;
    } else {
        XCUIElement *deleteKey = [[ClearText shared] deleteKey];
        [deleteKey resolve];

        if (deleteKey && deleteKey.exists) {
            [ClearText tapDeleteKeyToDeleteString:string
                                        deleteKey:deleteKey];
        } else {
            [ClearText typeDeleteCharacterToDeleteString:string
                                          firstResponder:(XCUIElement *)firstResponder];
        }

        if (deleteKey == nil || !deleteKey.exists) {
            for (NSUInteger index = 0; index < [string length]; index++) {

            }
        } else {
        }

        completion(nil);
        return nil;
    }
}

+ (void)tapDeleteKeyToDeleteString:(NSString *)string
                         deleteKey:(XCUIElement *)deleteKey {
    NSLog(@"Clearing text with by tapping the delete key");
    // There are cases where the deleteKey does not respond to wdFrame.
    CGRect frame;
    if (![deleteKey respondsToSelector:@selector(wdFrame)]) {
        frame = [deleteKey frame];
    } else {
        frame = [deleteKey wdFrame];
    }

    // There are cases where we cannot find a hit point.
    if (frame.origin.x <= 0.0 || frame.origin.y <= 0.0) {
        NSString *message;
        message = [NSString stringWithFormat:@"Keyboard delete key did not have a valid"
                   "hit point: %@", NSStringFromCGRect(frame)];
        @throw [CBXException withMessage:message];
    }

    CGFloat x = CGRectGetMinX(frame) + (CGRectGetWidth(frame)/2.0);
    CGFloat y = CGRectGetMinY(frame) + (CGRectGetHeight(frame)/2.0);

    NSDictionary *body =
    @{
      @"gesture" : @"touch",
      @"options" : @{},
      @"specifiers" : @{@"coordinate" : @{ @"x" : @(x), @"y" : @(y)}}
      };

    CompletionBlock completion = ^(NSError *error) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Encountered an"
            " error tapping the keyboard delete key: %@ for element %@",
                                 error, deleteKey];
            @throw [CBXException withMessage:message];
        }
    };
    for (NSUInteger index = 0; index < [string length]; index++) {
        [GestureFactory executeGestureWithJSON:body
                                    completion:completion];
    }
}

+ (void)typeDeleteCharacterToDeleteString:(NSString *)string
                           firstResponder:(XCUIElement *)firstResponder {
    NSLog(@"Clearing text by typing the delete character");
    BOOL isArm64 = [[CBXDevice sharedDevice] isArm64];
    if (isArm64) {
        NSLog(@"Device has arm64 architecture: %@", [[CBXDevice sharedDevice] armVersion]);
    } else {
        NSLog(@"Device does not have arm64 architecture: %@",
              [[CBXDevice sharedDevice] armVersion]);
    }

    for (NSUInteger index = 0; index < [string length]; index++) {
        [ThreadUtils runSync:^(BOOL *setToTrueWhenDone) {
            [[Testmanagerd get]
             _XCT_sendString:@"\b"
             maximumFrequency:CBX_DEFAULT_SEND_STRING_FREQUENCY
             completion:^(NSError *innerError) {
                 *setToTrueWhenDone = YES;
                 if (innerError) {
                     @throw [CBXException withMessage:@"Error performing gesture"];
                 }
             }];
        }];
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
    if ([elements count] == 0) {
        NSLog(@"Expected 1 element to match type 'Key' and id 'delete', found none");
        return nil;
    } else if (elements.firstObject == nil) {
        return nil;
    } else if ([elements count] != 1) {
        NSLog(@"Expected 1 element to match type 'Key' and id 'delete', found %@",
              @([elements count]));
        return elements[0];
    } else {
        return elements[0];
    }
}

- (XCUIElement *)firstResponder {
    TextInputFirstResponderProvider *provider = [TextInputFirstResponderProvider new];
    return [provider firstResponder];
}

@end

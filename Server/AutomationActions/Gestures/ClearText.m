
#import "ClearText.h"
#import "TextInputFirstResponderProvider.h"
#import "Testmanagerd.h"
#import "ThreadUtils.h"
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
        NSString *message = @"Can not clear text: no element has focus";
        NSError *error = [NSError errorWithDomain:CBXWebServerErrorDomain
                                             code:1
                                         userInfo:@{NSLocalizedDescriptionKey : message}];
        completion(error);
        return nil;
    }

    NSString *string = firstResponder.value;

    if (!string || [string length] == 0) {
        NSLog(@"There is no text in the element with keyboard focus %@",
              [JSONUtils snapshotOrElementToJSON:firstResponder]);
        completion(nil);
        return nil;
    }

    XCUIElement *deleteKey = [[ClearText shared] deleteKey];

    NSError *error = nil;
    BOOL success = NO;
    if (deleteKey && deleteKey.exists) {
        success = [ClearText tapDeleteKeyToDeleteString:string
                                              deleteKey:deleteKey
                                                  error:&error];
    } else {
        success = [ClearText typeDeleteCharacterToDeleteString:string
                                                         error:&error];
    }

    if (!success) {
        NSLog(@"Failed to clear text: %@", error);
    }

    completion(error);
    return nil;
}

+ (BOOL)tapDeleteKeyToDeleteString:(NSString *)string
                         deleteKey:(XCUIElement *)deleteKey
                             error:(NSError **)error {
    NSLog(@"Clearing text with by tapping the delete key");

    CGRect frame;
    if (![deleteKey respondsToSelector:@selector(wdFrame)]) {
        frame = [deleteKey frame];
    } else {
        frame = [deleteKey wdFrame];
    }

    // There are cases where we cannot find a hit point.
    if (frame.origin.x <= 0.0 || frame.origin.y <= 0.0) {
        NSString *message;
        message = [NSString stringWithFormat:@"Keyboard delete key did not have a valid "
                   "hit point: %@",
                   NSStringFromCGRect(frame)];
        *error = [NSError errorWithDomain:CBXWebServerErrorDomain
                                     code:1
                                 userInfo:@{NSLocalizedDescriptionKey : message }];
        return NO;
    }

    CGFloat x = CGRectGetMinX(frame) + (CGRectGetWidth(frame)/2.0);
    CGFloat y = CGRectGetMinY(frame) + (CGRectGetHeight(frame)/2.0);

    NSDictionary *body =
    @{
      @"gesture" : @"touch",
      @"options" : @{},
      @"specifiers" : @{@"coordinate" : @{ @"x" : @(x), @"y" : @(y)}}
      };

    __block NSError *outerError = nil;
    BOOL success = YES;
    for (NSUInteger index = 0; index < [string length]; index++) {
        [GestureFactory executeGestureWithJSON:body
                                    completion:^(NSError *innerError) {
                                        outerError = innerError;
                                    }];
        if (outerError) {
            NSLog(@"Encountered an error touching the keyboard delete key: %@", outerError);
            NSLog(@"Error occurred on the %@ tap of %@ required taps", @(index + 1),
                  @([string length]));
            NSLog(@"Delete key: %@", [JSONUtils snapshotOrElementToJSON:deleteKey]);
            success = NO;
            break;
        }
    }

    if (error) { *error = outerError; }
    return success;
}

+ (BOOL)typeDeleteCharacterToDeleteString:(NSString *)string
                                    error:(NSError **)error {
    NSLog(@"Clearing text by typing the delete character");

    BOOL success = YES;
    __block NSError *outerError = nil;
    for (NSUInteger index = 0; index < [string length]; index++) {
        [ThreadUtils runSync:^(BOOL *setToTrueWhenDone) {
            [[Testmanagerd get]
             _XCT_sendString:@"\b"
             maximumFrequency:CBX_DEFAULT_SEND_STRING_FREQUENCY
             completion:^(NSError *innerError) {
                 outerError = innerError;
                 if (innerError) {
                     NSLog(@"Encountered error typing text: %@", innerError);
                 }
                 *setToTrueWhenDone = YES;
             }];
        }];

        if (outerError) {
            NSLog(@"Error occurred on the %@ character of %@ required characters",
                  @(index + 1), @([string length]));
            success = NO;
            break;
        }
    }

    if (error) { *error = outerError; }
    return success;
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
    }

    if ([elements count] != 1) {
        NSLog(@"Expected 1 element to match type 'Key' and id 'delete', found %@",
              @([elements count]));
    }
    XCUIElement *deleteKey = elements[0];

    if (!deleteKey.lastSnapshot) {
        [deleteKey resolve];
    }

    return deleteKey;
}

- (XCUIElement *)firstResponder {
    TextInputFirstResponderProvider *provider = [TextInputFirstResponderProvider new];
    return [provider firstResponder];
}

@end


#import "InvalidArgumentException.h"
#import "Testmanagerd.h"
#import "ThreadUtils.h"
#import "EnterText.h"
#import "CBXConstants.h"
#import "Application.h"
#import "TextInputFirstResponderProvider.h"
#import "XCUIElement.h"
#import "XCElementSnapshot.h"
#import "XCUIElement+WebDriverAttributes.h"
#import "CBXMachClock.h"
#import "CBXWaiter.h"
#import "XCUIApplication+DeviceAgentAdditions.h"

@interface EnterText ()

+ (NSArray<NSString *> *)arrayOfStringsByChunkingString:(NSString *)string
                                                 length:(NSUInteger)chunkLength;

@end

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

    // TODO: Need to assert that a keyboard is showing and that there is a first responder.
    [EnterText waitForKeyboardAnimation];

    TextInputFirstResponderProvider *provider = [TextInputFirstResponderProvider new];
    XCUIElement *responder = [provider firstResponderOrApplication];
    [responder resolve];

    // Avoid long text which can lead to:
    //
    // Enqueue Failure: UI Testing Failure - Failed to receive event delivery
    // confirmation within 20.0s of the original dispatch.
    //
    // when using `XCUIElement#typeText:`.
    //
    // The text input rate is ~12 characters/second (derived empirically).
    //
    // In 20 seconds, we can expect to type ~240 characters.
    //
    // The 20 second time out is defined on Apple's side of the fence.  Let's assume that
    // the 20 second timeout can be as low 10 seconds and also assume that the characters
    // per second is 10.  This means we should chunk text to 100 characters.
    //
    // I have tried using `#typeText:`, but we still see:
    //
    // * Timed out waiting for key event to complete
    //
    // which is the result of:
    //
    // [UIKeyboardInputManagerClient handleError:forRequest:] will retry sending
    //   handleKeyboardInput:keyboardState:completionHandler: to keyboard daemon after
    //   receiving Error Domain=NSCocoaErrorDomain Code=4097 "connection to service named
    //   com.apple.TextInput" UserInfo={NSDebugDescription=connection to service named
    //   com.apple.TextInput}
    // com.apple.CoreSimulator.SimDevice.6DD279B3-7FED-4902-96F4-618D55540ADC.launchd_sim[16869]
    //  (com.apple.TextInput.kbd[16986]): Service exited due to signal: Segmentation fault: 11
    NSArray<NSString *> *chunks = [EnterText arrayOfStringsByChunkingString:string
                                                                     length:100];

    // _XCT_sendString: fails more often with `Timed out wait for key event` than
    // XCUIElement#typeText:.
    for (NSString *chunk in chunks) {
        [responder typeText:chunk];
    }

    completion(nil);
    return nil;
}

+ (void)waitForKeyboardAnimation {
    NSTimeInterval startTime = [[CBXMachClock sharedClock] absoluteTime];

    [[Application currentApplication] cbx_resolvedSnapshot];

    XCUIElement *keyboard = [[Application currentApplication] keyboard];
    __block CGRect previousFrame = keyboard.wdFrame;
    BOOL stable = [CBXWaiter waitWithTimeout:5 untilTrue:^BOOL {
        [keyboard resolve];
        BOOL sameFrame = CGRectEqualToRect(previousFrame, keyboard.wdFrame);
        previousFrame = keyboard.wdFrame;
        return sameFrame;
    }];

    NSTimeInterval elapsed = [[CBXMachClock sharedClock] absoluteTime] - startTime;
    if (stable) {
        NSLog(@"Waited %@ seconds for keyboard animation", @(elapsed));
    } else {
        NSLog(@"Timed out waiting after %@ seconds for keyboard animation", @(elapsed));
    }
}

+ (NSArray<NSString *> *)arrayOfStringsByChunkingString:(NSString *) string
                                                 length:(NSUInteger) chunkLength {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
    NSMutableString *mutable = [NSMutableString stringWithString:string];

    NSRange range;
    NSUInteger substringLength;
    NSString *substring = @"";
    while([mutable length] != 0) {
        substringLength = MIN([mutable length], chunkLength);
        range = NSMakeRange(0, substringLength);
        substring = [mutable substringWithRange:range];
        [result addObject:substring];
        [mutable deleteCharactersInRange:range];
    }

    return [NSArray arrayWithArray:result];
}

@end

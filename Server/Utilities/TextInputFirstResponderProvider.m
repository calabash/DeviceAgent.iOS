#import "TextInputFirstResponderProvider.h"
#import "CBX-XCTest-Umbrella.h"
#import "Application.h"
#import "JSONUtils.h"
#import "CBXConstants.h"

@interface TextInputFirstResponderProvider ()

@property(strong) NSPredicate *predicate;
@property(strong) NSArray<NSNumber *> *elementTypes;

@end

@implementation TextInputFirstResponderProvider

- (instancetype)init {
    self = [super init];
    if (self) {
        _predicate = [NSPredicate predicateWithFormat:@"%K = %@",
                      @"hasKeyboardFocus",
                      @(YES)];
        // This is an optimization.  Querying all elements is for the one with keyboard
        // focus can be prohibitively expensive (tens of seconds).
        _elementTypes = @[@(XCUIElementTypeTextField),
                          @(XCUIElementTypeTextView),
                          @(XCUIElementTypeSecureTextField),
                          @(XCUIElementTypeSearchField),
                          @(XCUIElementTypeOther)];
    }
    return self;
}

- (XCUIElement *)firstResponder {
    XCUIApplication *application = [Application currentApplication];
    NSPredicate *predicate = self.predicate;
    XCUIElement *firstResponder = nil;
    for (NSNumber *number in self.elementTypes) {
        XCUIElementType type = (XCUIElementType)[number unsignedIntegerValue];
        XCUIElementQuery *firstResponderQuery = [application descendantsMatchingType:type];
        XCUIElementQuery *matching = [firstResponderQuery matchingPredicate:predicate];
        NSArray <XCUIElement *> *elements = [matching allElementsBoundByIndex];
        if ([elements count] == 1) {
            firstResponder = elements[0];
            DDLogDebug(@"Element with keyboard focus has type %@",
                  [JSONUtils stringForElementType:type]);
            break;
        }
    }
    if (!firstResponder) {
        DDLogDebug(@"Could not find an element with keyboard focus");
    }

    return firstResponder;
}

@end

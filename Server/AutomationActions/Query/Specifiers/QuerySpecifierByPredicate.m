
#import "QuerySpecifierByPredicate.h"
#import "JSONUtils.h"
#import "CBXException.h"
#import "CBX-XCTest-Umbrella.h"

@implementation QuerySpecifierByPredicate

+ (NSString *)name { return @"predicate_string"; }

/* The method uses matchingPredicate to find UI elements by any type of predicate. Please
 * The general form looks like:
 * 1. Using XCUIElementAttributes: identifier, title, label, value, elementType, enabled, selected, hasFocus, placeholderValue
 * Please, see XCUIElementAttributes protocol to check all the properties.
 * 2. Using AND/OR logic to construct compound predicates directly: "label MATCHES '(Safari|News)' AND elementType == 'StaticText'".
 * 3. Using any regular expressions: MATCHES, CONTAINS, ... .
 *
 * The full information about predicates and how to construct it can be found in official Apple source as:
 * 1. 'Predicate Programming Guide': https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Predicates/AdditionalChapters/Introduction.html#//apple_ref/doc/uid/TP40001789
 * 2. NSRegularExpression documentation: https://developer.apple.com/documentation/foundation/nsregularexpression?language=objc
 *
 * In this method, we replace only incoming element type on XCUIElementType int value.
 * All the rest things in predicate should be constructed as normal predicate regarding guidelines from the document above.
 */
- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query {
    NSString *actualPredicateString = self.value;
    NSString *resultPredicateString = nil;
    
    NSString *pattern = @"(.*)elementType(.*)";
    NSRange range = [actualPredicateString rangeOfString:pattern options:NSRegularExpressionSearch];
    
    if (range.location != NSNotFound) {
        NSLog(@"Predicate '%@' contains elementType. Proceeed with replacement of XCUIElementType String value on int value.", actualPredicateString);

        NSString *matchPattern = @"elementType == '(\\w+)'";
        NSRange matchRange = [actualPredicateString rangeOfString:matchPattern options:NSRegularExpressionSearch];

        if (matchRange.location != NSNotFound) {
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:matchPattern options:0 error:nil];
            NSString *actualMatch = [actualPredicateString substringWithRange:matchRange];
            NSString *replacementString = [self replacementStringForElementType:actualMatch];
            
            resultPredicateString = [regex stringByReplacingMatchesInString:actualPredicateString options:0 range:NSMakeRange(0, [actualPredicateString length]) withTemplate:replacementString];
            NSLog(@"Replace original predicate '%@' with the replacement: %@", actualPredicateString, resultPredicateString);
        } else {
            @throw [CBXException withFormat:@"Can not parse element type. Actual string: '%@'. Expected type predicate form as: elementType == 'Button'", self.value];
        }
    } else {
        resultPredicateString = actualPredicateString;
        NSLog(@"Predicate does not contain elementType attribute. Proceeed with the original value: %@", resultPredicateString);
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:resultPredicateString];
    
    return [query matchingPredicate:predicate];
}

/*
 * Replace any occurences of XCUIElementType from string value with single quotes into int value.
 * The method return the original string with this replacement
 *
 * For example:
 * - incoming method argument as simple predicate of String type: original = "elementType == 'StaticText'"
 * - returns replacement string as predicate as well: replacementString = "elementType == 48"
 */
- (NSString *)replacementStringForElementType:(NSString *)original {
    // Find any text within single quotes
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"'(.*)'" options:0 error:NULL];
    NSTextCheckingResult *match = [regex firstMatchInString:original options:0 range:NSMakeRange(0, [original length])];
    NSString *shortTypeName = [original substringWithRange:[match rangeAtIndex:1]];
    NSLog(@"Found element type '%@' in predicate string: %@", shortTypeName, original);
    
    // Replace String type occurence on int
    NSUInteger type = [JSONUtils elementTypeForString:shortTypeName];
    NSLog(@"Replace element type '%@' into int: %i", shortTypeName, (unsigned int)type);
    
    // Provide new simple predicate with int element type
    NSString *replacementString = [NSString stringWithFormat:@"elementType == %i", (unsigned int)type];
    
    return replacementString;
}

@end

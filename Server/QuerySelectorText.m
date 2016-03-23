//
//  QuerySelectorText.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/22/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "QuerySelectorText.h"

static NSArray *textProperties;

@implementation QuerySelectorText
+ (void)load {
    textProperties = @[@"wdLabel", @"wdTitle", @"wdValue", @"wdPlaceholderValue"];
}

+ (NSString *)name { return @"text"; }

- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query {
    NSMutableString *predString = [NSMutableString string];
    for (NSString *prop in textProperties) {
        [predString appendFormat:@"%@ == '%@'", prop, self.value];
        if (prop != [textProperties lastObject]) {
            [predString appendString:@" OR "];
        }
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predString];
    return [query matchingPredicate:predicate];
}
@end

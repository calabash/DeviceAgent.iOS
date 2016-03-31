//
//  QuerySelectorTextLike.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/23/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "QuerySelectorTextLike.h"

@implementation QuerySelectorTextLike

+ (NSString *)name { return @"text_like"; }

- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query {
    NSMutableString *predString = [NSMutableString string];
    for (NSString *prop in [QuerySelectorText textProperties]) {
        [predString appendFormat:@"%@ LIKE[cd] '*%@*'", prop, self.value];
        if (prop != [[QuerySelectorText textProperties] lastObject]) {
            [predString appendString:@" OR "];
        }
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predString];
    return [query matchingPredicate:predicate];
}
@end

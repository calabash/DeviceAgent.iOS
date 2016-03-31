//
//  QuerySelectorPropertyLike.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/23/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "QuerySelectorPropertyLike.h"

@implementation QuerySelectorPropertyLike
+ (NSString *)name { return @"property_like"; }

- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query {
    NSMutableString *predString = [NSMutableString string];
    NSDictionary *val = [QuerySelectorProperty parseValue:self.value];
    
    [predString appendFormat:@"%@ LIKE[cd] '*%@*'", val[@"key"], val[@"value"]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predString];
    return [query matchingPredicate:predicate];
}
@end

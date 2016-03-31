//
//  QuerySelectorId.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/22/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "QuerySelectorId.h"

@implementation QuerySelectorId

+ (NSString *)name { return @"id"; }

- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query {
    return [query matchingIdentifier:self.value];
}
@end

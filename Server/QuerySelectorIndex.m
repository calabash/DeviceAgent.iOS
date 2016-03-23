//
//  QuerySelectorIndex.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/23/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "QuerySelectorIndex.h"

@implementation QuerySelectorIndex

+ (QuerySelectorExecutionPriority)executionPriority {
    return kQuerySelectorExecutionPriorityLast;
}

+ (NSString *)name { return @"index"; }

- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query {
    return [query elementBoundByIndex:[self.value integerValue] /* returns an XCUIElement */ ].query;
}
@end

//
//  QuerySelector.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/22/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import <XCTest/XCUIElementQuery.h>
#import "XCUIApplication.h"
#import "CBApplication.h"
#import "QuerySelector.h"

@implementation QuerySelector

+ (QuerySelectorExecutionPriority)executionPriority {
    return kQuerySelectorExecutionPriorityAny;
}

+ (NSString *)name { return nil; }

+ (instancetype)withValue:(id)value {
    QuerySelector *qs = [self new];
    qs.value = value;
    return qs;
}

- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query {
    _must_override_exception;
}
- (XCUIElementQuery *)applyToQuery:(XCUIElementQuery *)query {
    if (query == nil) {
        XCUIElementQuery *all = [[CBApplication currentApplication].query descendantsMatchingType:XCUIElementTypeAny];
        return [self applyInternal:all];
    } else {
        return [self applyInternal:query];
    }
}
@end

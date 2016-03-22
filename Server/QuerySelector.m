//
//  QuerySelector.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/22/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBApplication.h"
#import "XCUIApplication.h"
#import "QuerySelector.h"

@implementation QuerySelector

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
        return [self applyInternal:[CBApplication currentApplication].query];
    } else {
        return [self applyInternal:query];
    }
}
@end

//
//  CBElementQuery.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/18/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "QuerySelectorFactory.h"
#import "CBQuery.h"

@implementation CBQuery
+ (NSMutableDictionary *)specifiersFromQueryString:(NSString *)queryString {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    //TODO: parse string
    
    return dict;
}

+ (NSArray <CBQuery *> *)elementsWithSpecifierKey:(NSString *)key value:(id)value {
    if ([key isEqualToString:CB_COORDINATE_KEY]) {
        if ([value isKindOfClass:[NSArray class]]) {
            value = @{
                      @"x" : value[0],
                      @"y" : value[1]
                      };
        }
    }
    return nil;
}

- (NSDictionary *)coordinate {
    return self.specifiers[CB_COORDINATE_KEY];
}

- (NSArray<NSDictionary *> *)coordinates {
    return self.specifiers[CB_COORDINATES_KEY];
}

+ (CBQuery *)withSpecifiers:(NSDictionary *)specifiers
          collectWarningsIn:(NSMutableArray <NSString *> *)warnings {
    CBQuery *e = [self new];
    NSMutableDictionary *s = [(specifiers ?: @{}) mutableCopy];
    
    /*
        Support for calabash query strings
     */
    if (s[@"query"]) {
        NSMutableDictionary *queryStringSpecifiers = [self specifiersFromQueryString:s[@"query"]];
        [s removeObjectForKey:@"query"];
        [s addEntriesFromDictionary:queryStringSpecifiers];
    }
    
    e.specifiers = s;
    NSMutableArray *selectors = [NSMutableArray array];
    
    for (NSString *key in e.specifiers) {
        QuerySelector *qs = [QuerySelectorFactory selectorWithKey:key value:e.specifiers[key]];
        if (qs) {
            [selectors addObject:qs];
        } else {
            [warnings addObject:[NSString stringWithFormat:@"'%@' is an invalid query selector", key]];
        }
    }
    
    //TODO: if there's a child query, add it as a sub query somehow...
    
    e.selectors = selectors;
    return e;
}

- (NSArray <XCUIElement *> *)execute {
    if (_specifiers.count == 0) return nil;

    XCUIElementQuery *query = nil;
    for (QuerySelector *querySelector in self.selectors) {
        query = [querySelector applyToQuery:query];
    }
    
    //TODO: if there's a child query, recurse
    //
    //if (childQuery) {
    //    return [childQuery execute];
    //} else {
    
    return [query allElementsBoundByIndex];
    //}
}

- (NSDictionary *)toDict {
    return [[self specifiers] mutableCopy];
}

- (NSString *)description {
    return [[self toDict] description];
}

- (NSArray <NSString *> *)requiredSpecifierDelta:(NSArray <NSString *> *)required {
    NSMutableArray *s1 = [self.specifiers.allKeys mutableCopy];
    NSMutableArray *s2 = [required mutableCopy];
    [s2 removeObjectsInArray:s1];
    return s2;
}

- (NSArray <NSString *> *)optionalSpecifierDelta:(NSArray <NSString *> *)optional {
    NSMutableArray *s1 = [self.specifiers.allKeys mutableCopy];
    NSMutableArray *s2 = [optional mutableCopy];
    [s1 removeObjectsInArray:s2];
    return s1;
}

@end

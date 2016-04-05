//
//  CBElementQuery.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/18/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "QuerySelectorFactory.h"
#import "JSONUtils.h"
#import "CBQuery.h"

@implementation CBQuery
+ (NSArray <CBQuery *> *)elementsWithSpecifierKey:(NSString *)key value:(id)value {
    if ([key isEqualToString:CB_COORDINATE_KEY]) {
        if ([value isKindOfClass:[NSArray class]]) {
            value = @{
                      CB_X_KEY : value[0],
                      CB_Y_KEY : value[1]
                      };
        }
    }
    return nil;
}

- (NSDictionary *)coordinate {
    return self[CB_COORDINATE_KEY];
}

- (NSArray<NSDictionary *> *)coordinates {
    return self[CB_COORDINATES_KEY];
}

+ (NSArray <NSString *> *)ignoredKeys {
    return @[
             @"gesture",
             @"coordinate",
             @"coordinates",
             ];
}

+ (CBQuery *)withQueryConfiguration:(QueryConfiguration *)queryConfig {
    CBQuery *e = [self new];
    
    NSMutableArray *selectors = [NSMutableArray array];
    
    for (NSString *key in queryConfig.specifiers) {
        if ([[CBQuery ignoredKeys] containsObject:key]) { continue; }
        
        QuerySelector *qs = [QuerySelectorFactory selectorWithKey:key
                                                            value:queryConfig[key]];
        if (qs) {
            [selectors addObject:qs];
        } else {
            @throw [CBInvalidArgumentException withFormat:@"'%@' is an invalid query selector", key];
        }
    }
    
    /*
        Sort based on selector priority. E.g. index should come last
     */
    [selectors sortUsingComparator:^NSComparisonResult(QuerySelector  *_Nonnull s1, QuerySelector *_Nonnull s2) {
        QuerySelectorExecutionPriority p1 = [s1.class executionPriority];
        QuerySelectorExecutionPriority p2 = [s2.class executionPriority];
        return [@(p1) compare:@(p2)];
    }];
    
    //TODO: if there's a child query, add it as a sub query somehow...
    
    e.selectors = selectors;
    return e;
}

- (NSArray <XCUIElement *> *)execute {
    if (_queryConfiguration.specifiers.count == 0) return nil;

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
    return @{
             @"specifiers" : self.queryConfiguration.specifiers
             };
}

- (NSString *)toJSONString {
    return [JSONUtils objToJSONString:[self toDict]];
}

- (NSString *)description {
    return [[self toDict] description];
}

- (id)objectForKeyedSubscript:(NSString *)key {
    return self.queryConfiguration[key];
}

@end

//
//  CBElementQuery.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/18/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CoordinateQueryConfiguration.h"
#import "QuerySelectorFactory.h"
#import "CBCoordinateQuery.h"
#import "CBException.h"
#import "JSONUtils.h"
#import "CBQuery.h"

@implementation CBQuery

+ (JSONKeyValidator *)validator {
    return [JSONKeyValidator withRequiredKeys:@[]
                                    optionalKeys:[QuerySelectorFactory supportedSelectorNames]];
}

- (id)init {
    if (self = [super init]) {
        self.isCoordinateQuery = NO;
    }
    return self;
}

- (CBCoordinateQuery *)asCoordinateQuery {
    return [CBCoordinateQuery withQueryConfiguration:self.queryConfiguration];
}

+ (instancetype)withQueryConfiguration:(QueryConfiguration *)queryConfig {
    CBQuery *e = [self new];
    e.queryConfiguration = queryConfig;
    e.isCoordinateQuery = queryConfig.isCoordinateQuery;
    return e;
}

- (NSArray<XCUIElement *> *)execute {
    if (_queryConfiguration.selectors.count == 0) return nil;

    XCUIElementQuery *query = nil;
    for (QuerySelector *querySelector in self.queryConfiguration.selectors) {
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
    return self.queryConfiguration.raw;
}

- (NSString *)toJSONString {
    return [JSONUtils objToJSONString:[self toDict]];
}

- (NSString *)description {
    return [[self toDict] ?: @{} description];
}

- (id)objectForKeyedSubscript:(NSString *)key {
    return self.queryConfiguration[key];
}

@end

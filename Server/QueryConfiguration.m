//
//  QueryOptions.m
//  CBXDriver
//
//  Created by Chris Fuentes on 4/4/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CoordinateQueryConfiguration.h"
#import "CBInvalidArgumentException.h"
#import "QuerySelectorFactory.h"
#import "QueryConfiguration.h"
#import "JSONUtils.h"

@interface QueryConfiguration ()
@property (nonatomic, strong) JSONKeyValidator *validator;
@end

@implementation QueryConfiguration
- (id)init {
    if (self = [super init]) {
        self.selectors = [NSMutableArray array];
        self.isCoordinateQuery = NO;
    }
    return self;
}

+ (NSMutableDictionary *)specifiersFromQueryString:(NSString *)queryString {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    //TODO: parse string. Maybe import the AST lib from calabash-ios-server.
    
    return dict;
}

- (void)setupQuerySelectors {
    NSArray *keys = [self.raw allKeys];
    NSMutableArray *selectors = [NSMutableArray array];

    for (NSString *key in keys) {
        /*
            If we're dealing with a coordinate query, selectors don't matter since the element
            should be uniquely identified by the coordinates.
         */
        if ([key isEqualToString:CB_COORDINATE_KEY] ||
            [key isEqualToString:CB_COORDINATES_KEY]) {
            self.isCoordinateQuery = YES;
            break;
        }
        QuerySelector *qs = [QuerySelectorFactory selectorWithKey:key
                                                            value:self[key]];
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
    
    self.selectors = selectors;
}

+ (instancetype)withJSON:(NSDictionary *)j
               validator:(JSONKeyValidator *)validator {
    NSMutableDictionary *json = [j mutableCopy];
    
    /*
     Support for calabash query strings
     */
    if (json[CB_QUERY_KEY]) {
        NSMutableDictionary *queryStringSpecifiers = [self specifiersFromQueryString:json[CB_QUERY_KEY]];
        [json removeObjectForKey:CB_QUERY_KEY];
        [json addEntriesFromDictionary:queryStringSpecifiers];
    }
    
    QueryConfiguration *q = [super withJSON:json
                                  validator:validator];
    q.validator = validator;
    
    [q setupQuerySelectors];
    
    return q;
}

- (CoordinateQueryConfiguration *)asCoordinateQueryConfiguration {
    CoordinateQueryConfiguration *config = [CoordinateQueryConfiguration withJSON:self.raw
                                                                        validator:self.validator];
    
    if (self.raw[CB_COORDINATE_KEY]) {
        id json = self.raw[CB_COORDINATE_KEY];
        [JSONUtils validatePointJSON:json];
        config.coordinate = [CBCoordinate withJSON:json];
    }
    
    if (self.raw[CB_COORDINATES_KEY]) {
        NSMutableArray *coords = [NSMutableArray array];
        for (id json in self.raw[CB_COORDINATES_KEY]) {
            [JSONUtils validatePointJSON:json];
            [coords addObject:[CBCoordinate withJSON:json]];
        }
        config.coordinates = coords;
    }
    
    return config;
}

@end

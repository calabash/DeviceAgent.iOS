//
//  QueryOptions.m
//  CBXDriver
//
//  Created by Chris Fuentes on 4/4/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBInvalidArgumentException.h"
#import "QueryConfiguration.h"

@interface QueryConfiguration ()
@property (nonatomic, strong) NSDictionary *raw;
@end

@implementation QueryConfiguration
- (id)init {
    if (self = [super init]) {
        self.specifiers = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)withJSON:(NSDictionary *)json {
    QueryConfiguration *q = [QueryConfiguration new];
    q.raw = json;
    return q;
}

+ (NSMutableDictionary *)specifiersFromQueryString:(NSString *)queryString {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    //TODO: parse string
    
    return dict;
}

+ (instancetype)withJSON:(NSDictionary *)j
      requiredSpecifiers:(NSArray <NSString *> *)requiredSpecifiers
      optionalSpecifiers:(NSArray <NSString *> *)optionalSpecifiers {
    
    NSMutableDictionary *json = [j mutableCopy];
    
    QueryConfiguration *q = [self withJSON:json];
    
    /*
     Support for calabash query strings
     */
    if (json[CB_QUERY_KEY]) {
        NSMutableDictionary *queryStringSpecifiers = [self specifiersFromQueryString:json[CB_QUERY_KEY]];
        [json removeObjectForKey:CB_QUERY_KEY];
        [json addEntriesFromDictionary:queryStringSpecifiers];
    }
    
    NSArray *keys = [json allKeys];
    /*
        Ensure that every key is accepted in some manner
     */
    for (NSString *k in keys) {
        if (!([requiredSpecifiers containsObject:k] ||
             [optionalSpecifiers containsObject:k] )) {
            @throw [CBInvalidArgumentException withFormat:@"Unsupported key: '%@'", k];
        }
    }
    
    /*
        Ensure that all required keys are present in the json
     */
    for (NSString *key in requiredSpecifiers) {
        if (![keys containsObject:key]) {
            @throw [CBInvalidArgumentException withFormat:@"Required key '%@' is missing.", key];
        }
    }
    
    [q.specifiers addObjectsFromArray:requiredSpecifiers];
    [q.specifiers addObjectsFromArray:optionalSpecifiers];
    
    return q;
}

- (id)objectForKeyedSubscript:(NSString *)key { return self.raw[key]; }

- (NSDictionary *)toDictionary { return self.raw; }
@end

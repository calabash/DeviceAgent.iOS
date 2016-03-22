//
//  CBElementQuery.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/18/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBQuery.h"

@implementation CBQuery
+ (NSMutableDictionary *)specifiersFromQueryString:(NSString *)queryString {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    //TODO: parse string
    
    return dict;
}

+ (NSArray <CBElementQuery *> *)elementsWithSpecifierKey:(NSString *)key value:(id)value {
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
    return self.subQuery ? [self.subQuery coordinate] : self.specifiers[CB_COORDINATE_KEY];
}

- (NSArray<NSDictionary *> *)coordinates {
    return self.subQuery ? [self.subQuery coordinates] : self.specifiers[CB_COORDINATES_KEY];
}

+ (CBQuery *)withSpecifiers:(NSDictionary *)specifiers {
    CBQuery *e = [self new];
    NSMutableDictionary *s = [specifiers mutableCopy];
    
    /*
     *  Subqueries should be removed from the main specifier dict, since
     *  they need to be parsed only after all elements in the specifiers are parsed.
     */
    NSString *subKey = s[@"child"] ? @"child" : s[@"parent"] ? @"parent" : nil;
    if (subKey) {
        CBQuery *sub = [self withQueryString:s[subKey][@"query"]
                                         specifiers:s[subKey]];
        e.subQuery = sub;
        [s removeObjectForKey:subKey];
    }
    
    e.specifiers = s ?: @{};
    return e;
}

+ (CBQuery *)withQueryString:(NSString *)queryString specifiers:(NSDictionary *)specifiers {
    NSMutableDictionary *queryStringSpecifiers = [self specifiersFromQueryString:queryString];
    [queryStringSpecifiers addEntriesFromDictionary:specifiers];
    
    return [self withSpecifiers:queryStringSpecifiers];
}

- (void)filterResults:(NSMutableArray <XCUIElement *> *)results bySpecifiers:(NSMutableDictionary *)specifiers {
    if (specifiers.count == 0) return;
    
    NSString *specifierKey = specifiers.allKeys[0];
//    id specifierValue = specifiers[specifierKey];
    
    //TODO apply
    
    [specifiers removeObjectForKey:specifierKey];
    [self filterResults:results bySpecifiers:specifiers];
}

- (XCUIElement *)execute {
    if (_specifiers.count == 0) return nil;
    
//    NSString *specifierKey = _specifiers.allKeys[0];
//    id specifierValue = _specifiers[specifierKey];
    
    
    return nil;
}

- (NSDictionary *)toDict {
    NSMutableDictionary *dict = [[self specifiers] mutableCopy];
    if (self.subQuery) dict[@"sub"] = [self.subQuery toDict];
    return dict;
}

- (NSString *)description {
    return [[self toDict] description];
}
@end

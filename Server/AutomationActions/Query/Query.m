
#import "CoordinateQueryConfiguration.h"
#import "QuerySpecifierFactory.h"
#import "CoordinateQuery.h"
#import "CBXException.h"
#import "Application.h"
#import "JSONUtils.h"
#import "Query.h"
#import "XCApplicationQuery.h"
#import "XCUIApplication.h"
#import "XCUIApplication+DeviceAgentAdditions.h"

@implementation Query

+ (JSONKeyValidator *)validator {
    return [JSONKeyValidator withRequiredKeys:@[]
                                 optionalKeys:[QuerySpecifierFactory supportedSpecifierNames]];
}

- (BOOL)isCoordinateQuery {
    return NO;
}

- (CoordinateQuery *)asCoordinateQuery {
    return [CoordinateQuery withQueryConfiguration:self.queryConfiguration.asCoordinateQueryConfiguration];
}

+ (instancetype)withQueryConfiguration:(QueryConfiguration *)queryConfig {
    Query *e = [self new];
    e.queryConfiguration = queryConfig;
    return e;
}

- (NSArray<XCUIElement *> *)execute {
    //TODO throw exception if count == 0
    if (_queryConfiguration.selectors.count == 0) {
        return nil;
    }

    if ([Application currentApplication] == nil) {
        @throw [CBXException withMessage:@"Can not perform queries until application has been launched!"];
    }

    [[Application currentApplication] cbx_resolvedSnapshot];

    XCUIElementQuery *query = [[Application currentApplication].query
                               descendantsMatchingType:XCUIElementTypeAny];;
    for (QuerySpecifier *specifier in self.queryConfiguration.selectors) {
        query = [specifier applyToQuery:query];
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

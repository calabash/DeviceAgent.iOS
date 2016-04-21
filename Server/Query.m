
#import "CoordinateQueryConfiguration.h"
#import "QuerySpecifierFactory.h"
#import "CoordinateQuery.h"
#import "CBXException.h"
#import "JSONUtils.h"
#import "Query.h"

@implementation Query

+ (JSONKeyValidator *)validator {
    return [JSONKeyValidator withRequiredKeys:@[]
                                 optionalKeys:[QuerySpecifierFactory supportedSpecifierNames]];
}

- (id)init {
    if (self = [super init]) {
        self.isCoordinateQuery = NO;
    }
    return self;
}

- (CoordinateQuery *)asCoordinateQuery {
    return [CoordinateQuery withQueryConfiguration:self.queryConfiguration.asCoordinateQueryConfiguration];
}

+ (instancetype)withQueryConfiguration:(QueryConfiguration *)queryConfig {
    Query *e = [self new];
    e.queryConfiguration = queryConfig;
    e.isCoordinateQuery = queryConfig.isCoordinateQuery;
    return e;
}

- (NSArray<XCUIElement *> *)execute {
    //TODO throw exception if count == 0
    if (_queryConfiguration.selectors.count == 0) return nil;

    /*
        Building the XCUIElementQuery
     */
    XCUIElementQuery *query = nil;
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


#import "CoordinateQueryConfiguration.h"
#import "InvalidArgumentException.h"
#import "QuerySpecifierFactory.h"
#import "QueryConfiguration.h"
#import "JSONUtils.h"
#import "CBXConstants.h"

@interface QueryConfiguration ()
@property (nonatomic, strong) JSONKeyValidator *validator;
@end

@implementation QueryConfiguration
- (id)init {
    if (self = [super init]) {
        self.selectors = [NSMutableArray array];
    }
    return self;
}

- (BOOL)isCoordinateQuery {
    return self.raw[CBX_COORDINATE_KEY] != nil && self.raw[CBX_COORDINATES_KEY] != nil;
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
        QuerySpecifier *qs = [QuerySpecifierFactory specifierWithKey:key
                                                               value:self[key]];
        if (qs) {
            [selectors addObject:qs];
        } else {
            @throw [InvalidArgumentException withFormat:@"'%@' is an invalid query selector", key];
        }
    }
    
    /*
     Sort based on selector priority. E.g. index should come last
     */
    [selectors sortUsingComparator:^NSComparisonResult(QuerySpecifier  *_Nonnull s1, QuerySpecifier *_Nonnull s2) {
        QuerySpecifierExecutionPriority p1 = [s1.class executionPriority];
        QuerySpecifierExecutionPriority p2 = [s2.class executionPriority];
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
    if (json[CBX_QUERY_KEY]) {
        NSMutableDictionary *queryStringSpecifiers = [self specifiersFromQueryString:json[CBX_QUERY_KEY]];
        [json removeObjectForKey:CBX_QUERY_KEY];
        [json addEntriesFromDictionary:queryStringSpecifiers];
    }
    
    QueryConfiguration *q = [super withJSON:json
                                  validator:validator];
    q.validator = validator;
    
    [q setupQuerySelectors];
    
    return q;
}

- (CoordinateQueryConfiguration *)asCoordinateQueryConfiguration {
    return [CoordinateQueryConfiguration withJSON:self.raw validator:self.validator];
}

@end

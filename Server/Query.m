
#import "CoordinateQueryConfiguration.h"
#import "QuerySpecifierFactory.h"
#import "CoordinateQuery.h"
#import "CBXException.h"
#import "Application.h"
#import "JSONUtils.h"
#import "Query.h"

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
    if (_queryConfiguration.selectors.count == 0) return nil;
    if ([Application currentApplication] == nil) {
        @throw [CBXException withMessage:@"Can not perform queries until application has been launched!"];
    }

    /*
        Building the XCUIElementQuery
     */
    XCUIElementQuery *query = [[Application currentApplication].query descendantsMatchingType:XCUIElementTypeAny];;
    for (QuerySpecifier *specifier in self.queryConfiguration.selectors) {
        query = [specifier applyToQuery:query];
    }


    NSArray<XCUIElement *> *elements = @[];

    // I have seen this happen when querying for a UIAlertView button directly after the
    // alert appears.  I have also seen it happen when touching a UIAlertView button too
    // soon after the alert appears.
    @try {
        //TODO: if there's a child query, recurse
        //
        //if (childQuery) {
        //    return [childQuery execute];
        //}
        elements = [query allElementsBoundByIndex];
    } @catch (NSException *exception) {
        NSLog(@"DeviceAgent caught an exception while calling allElementsBoundByIndex");

        NSLog(@"===  EXCEPTION ===");
        NSLog(@"%@", exception);
        NSLog(@"");

        NSLog(@"=== STACK SYMBOLS === ");
        NSLog(@"%@", [exception callStackSymbols]);
        NSLog(@"");

        NSLog(@"=== RUNTIME DETAILS ===");
        NSLog(@"        query: %@", query);
    }
    return elements;
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

//
//  CBApplication+Queries.m
//  xcuitest-server
//

#import "CBApplication+Queries.h"
#import "XCElementSnapshot.h"
#import "XCAXClient_iOS.h"
#import "XCUIElement.h"
#import "JSONUtils.h"

@implementation CBApplication (Queries)
static NSArray <NSString *> *markedProperties;
static NSArray <NSString *> *identifierProperties;

+ (void)load {
    static dispatch_once_t oncet;
    dispatch_once(&oncet, ^{
        markedProperties = @[@"label", @"title", @"value", @"accessibilityLabel"];
        identifierProperties = @[@"identifier", @"accessibilityIdentifier"];
    });
}

/*
 * Tree
 */

+ (NSDictionary *)tree {
    return [self snapshotTree:[[self currentApplication] lastSnapshot]];
}

+ (NSDictionary *)snapshotTree:(XCElementSnapshot *)snapshot {
    NSMutableDictionary *json = [JSONUtils snapshotToJSON:snapshot];
    
    if (snapshot.children.count) {
        NSMutableArray *children = [NSMutableArray array];
        for (XCElementSnapshot *child in snapshot.children) {
            [children addObject:[self snapshotTree:child]];
        }
        json[@"children"] = children;
    }
    return json;
}

/*
    General Querying
 */

+ (NSArray <XCUIElement *> *)elementsMarked:(NSString *)text {
    return [self elementsWithAnyOfTheseProperties:markedProperties equalToValue:text];
}

+ (NSArray <XCUIElement *> *)elementsWithIdentifier:(NSString *)identifier {
    return [self elementsWithAnyOfTheseProperties:identifierProperties equalToValue:identifier];
}

+ (NSArray <XCUIElement *> *)elementsWithAnyOfTheseProperties:(NSArray *)properties
                                                 equalToValue:(NSString *)value {
    NSMutableString *predString = [NSMutableString string];
    for (NSString *prop in properties) {
        [predString appendFormat:@"%@ == '%@'", prop, value];
        if (prop != [properties lastObject]) {
            [predString appendString:@" OR "];
        }
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predString];
    XCUIElementQuery *query = [[[self currentApplication] descendantsMatchingType:XCUIElementTypeAny]
                               matchingPredicate:predicate];
    
    return [query allElementsBoundByIndex];
}

+ (NSArray <NSDictionary *> *)jsonForElementsWithAnyOfTheseProperties:(NSArray *)properties
                                                         equalToValue:(NSString *)value {
    NSArray *childElements = [self elementsWithAnyOfTheseProperties:properties
                                                       equalToValue:value];
    NSMutableArray *ret = [NSMutableArray array];
    
    //TODO: Should we check the application itself?
    for (XCUIElement *element in childElements) {
        [ret addObject:[JSONUtils elementToJSON:element]];
    }
    return ret;
}

+ (NSArray <NSDictionary *> *)jsonForElementsMarked:(NSString *)text {
    return [self jsonForElementsWithAnyOfTheseProperties:markedProperties
                                            equalToValue:text];
}

+ (NSArray <NSDictionary *> *)jsonForElementsWithID:(NSString *)identifier {
    return [self jsonForElementsWithAnyOfTheseProperties:identifierProperties
                                            equalToValue:identifier];
}
@end

//
//  CBApplication+Queries.m
//  xcuitest-server
//

#import "XCElementSnapshot-Hitpoint.h"
#import "Application+Queries.h"
#import "XCElementSnapshot.h"
#import "XCUIElementQuery.h"
#import "XCAXClient_iOS.h"
#import "XCUIElement.h"
#import "JSONUtils.h"

@implementation Application (Queries)
static NSArray <NSString *> *identifierProperties;

+ (void)load {
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        identifierProperties = @[@"identifier", @"accessibilityIdentifier"];
    });
}

/*
 * Tree
 */
+ (NSDictionary *)tree {
    if ([[self currentApplication] lastSnapshot] == nil) {
        [[[self currentApplication] applicationQuery] elementBoundByIndex:0];
        [[self currentApplication] resolve];
    }
    return [self snapshotTree:[[self currentApplication] lastSnapshot]];
}

+ (XCElementSnapshot *)elementAtCoordinates:(float)x :(float)y {
    XCElementSnapshot *appSnap = (XCElementSnapshot *)[[[self currentApplication] lastSnapshot] hitTest:CGPointMake(x, y)];
    return appSnap;
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

+ (XCUIElement *)elementWithIdentifier:(NSString *)identifier {
    NSArray *elements = [self elementsWithIdentifier:identifier];
    return elements.count > 0 ? [elements firstObject] : nil;
}

+ (NSArray <XCUIElement *> *)elementsWithIdentifier:(NSString *)identifier {
    return [[[[self currentApplication] descendantsMatchingType:XCUIElementTypeAny]
            matchingIdentifier:identifier] allElementsBoundByIndex];
}

+ (NSArray <XCUIElement *> *)elementsWithType:(NSString *)typeString {
    XCUIElementType type = [JSONUtils elementTypeForString:typeString];
    if ((int)type == -1) {
        @throw [[NSException alloc] initWithName:@"Invalid Element Type"
                                          reason:[NSString stringWithFormat:@"Invalid element type: %@", typeString]
                                        userInfo:nil];
    }
    XCUIElementQuery *query = [[self currentApplication] descendantsMatchingType:type];
    return [query allElementsBoundByIndex];
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

+ (NSArray <NSDictionary *> *)jsonForElementsWithID:(NSString *)identifier {
    NSArray *elements = [self elementsWithIdentifier:identifier];
    NSMutableArray *ret = [NSMutableArray array];

    //TODO: Should we check the application itself?
    for (XCUIElement *element in elements) {
        [ret addObject:[JSONUtils elementToJSON:element]];
    }
    return ret;
}

+ (NSArray <NSDictionary *> *)jsonForElementsWithType:(NSString *)type {
    NSArray *elements = [self elementsWithType:type];
    NSMutableArray *ret = [NSMutableArray array];

    //TODO: Should we check the application itself?
    for (XCUIElement *element in elements) {
        [ret addObject:[JSONUtils elementToJSON:element]];
    }
    return ret;
}
@end

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
+ (NSDictionary *)tree {
    return [self snapshotTree:[[self currentApplication] lastSnapshot]];
}

+ (NSArray *)elementsWithAnyOfTheseProperties:(NSArray *)properties equalToValue:(NSString *)value {
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
    
    NSArray *childElements = [query allElementsBoundByIndex];
    NSMutableArray *ret = [NSMutableArray array];
    
    //TODO: Should we check the application itself?
    for (XCUIElement *element in childElements) {
        [ret addObject:[JSONUtils elementToJSON:element]];
    }
    return ret;
}

+ (NSArray *)elementsMarked:(NSString *)text {
    return [self elementsWithAnyOfTheseProperties:@[@"label", @"title", @"value"]
                                     equalToValue:text];
}

+ (NSArray *)elementsWithID:(NSString *)identifier {
    return [self elementsWithAnyOfTheseProperties:@[@"identifier", @"accessibilityIdentifier"]
                                     equalToValue:identifier];
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
@end

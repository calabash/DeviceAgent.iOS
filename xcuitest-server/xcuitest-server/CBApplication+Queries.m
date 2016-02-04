//
//  CBApplication+Queries.m
//  xcuitest-server
//
//  Created by Chris Fuentes on 2/3/16.
//  Copyright © 2016 calabash. All rights reserved.
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

+ (NSArray *)viewsMarked:(NSString *)text {
    NSString *predString = [NSString stringWithFormat:@"label == '%@' OR title == '%@'",text, text];
    NSPredicate *pred = [NSPredicate predicateWithFormat:predString];
    XCUIElementQuery *query = [[[self currentApplication] descendantsMatchingType:XCUIElementTypeAny]
                               matchingPredicate:pred];
    
    NSArray *childElements = [query allElementsBoundByIndex];
    NSMutableArray *ret = [NSMutableArray array];
    
    //TODO: Should we check the application itself?
    for (XCUIElement *element in childElements) {
        [ret addObject:[JSONUtils elementToJSON:element]];
    }
    return ret;
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

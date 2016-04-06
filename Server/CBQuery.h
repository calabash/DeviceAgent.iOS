//
//  CBElementQuery.h
//  CBXDriver
//
//  Created by Chris Fuentes on 3/18/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QueryConfiguration.h"
#import "AutomationAction.h"
#import "QuerySelector.h"
#import "CBProtocols.h"
#import "CBConstants.h"
#import "XCUIElement.h"

@class CBCoordinateQuery;

@interface CBQuery : AutomationAction
@property (nonatomic, strong) QueryConfiguration *queryConfiguration;

/*
    Convenience indexing into query options
 */
- (id)objectForKeyedSubscript:(NSString *)key;

/*
    Coordinate based queries
 */
@property (nonatomic) BOOL isCoordinateQuery;
- (CBCoordinateQuery *)asCoordinateQuery;

/*
    General queries
 */
+ (instancetype)withQueryConfiguration:(QueryConfiguration *)queryConfig;

/*
    Perform the query, eval the results into XCUIElements
 */
- (NSArray <XCUIElement *> *)execute;

/*
    Debug description
 */
- (NSString *)toJSONString;
@end

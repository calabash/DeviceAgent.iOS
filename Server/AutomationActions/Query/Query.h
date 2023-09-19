
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import <Foundation/Foundation.h>
#import "AutomationAction.h"

@class QueryConfiguration;
@class CoordinateQuery;
@class XCUIElement;

/**
 Encapsulates the notion of a query for a particular element(s).
 */

@interface Query : AutomationAction
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, strong) QueryConfiguration *queryConfiguration;

/*
    Convenience indexing into query options
 */
- (id)objectForKeyedSubscript:(NSString *)key;

/**
 Convenience method for determining if the Query can be treated as a
 CoordinateQuery. 
 
 Coordinate-based queries are a special case of Query, since (in the case of
 Gestures) they already provide enough information to perform the gesture without
 needing to resolve any higher-level specifiers.
 
 It is therefore helpful to have a convenience method that indicates whether or
 not a Query should be treeted as a CoordinateQuery, since it is able to short-circuit
 the query evaluation logic for performing gestures.
 */
- (BOOL)isCoordinateQuery;


/**
 Convenience constructor to create a CoordinateQuery from a Query. Should be used in
 conjunction with isCoordinateQuery above.
 
 @exception InvalidArgumentException Thrown if the query is not actually a coordinate query
 (i.e., doesn't contain `coordinate` or `coordinates` as part of its config).
 */
- (CoordinateQuery *)asCoordinateQuery;

/**
Convenience constructor.
 
 @param queryConfig Configuration containing specifiers for the current query. 
 @return a new Query
 */
+ (instancetype)withQueryConfiguration:(QueryConfiguration *)queryConfig;

/**
 Perform the query, eval the results into XCUIElements
    
 @return a list of XCUIElement that matches all specifiers in the queryConfig
 */
- (NSArray <NSDictionary *> *)execute;
/*
    Debug description
 */
- (NSString *)toJSONString;
NS_ASSUME_NONNULL_END
@end

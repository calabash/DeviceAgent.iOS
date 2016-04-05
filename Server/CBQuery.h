//
//  CBElementQuery.h
//  CBXDriver
//
//  Created by Chris Fuentes on 3/18/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QueryConfiguration.h"
#import "QuerySelector.h"
#import "CBConstants.h"
#import "XCUIElement.h"

@interface CBQuery : NSObject
@property (nonatomic, strong) NSArray <QuerySelector *> *selectors;
@property (nonatomic, strong) QueryConfiguration *queryConfiguration;

/*
 Convenience indexing into query options
 */
- (id)objectForKeyedSubscript:(NSString *)key;

/*
    Coordinate based queries
 */
- (NSDictionary *)coordinate;  //e.g. for tap_coordinate
- (NSArray <NSDictionary *> *)coordinates; //e.g., for drag_coordinates

/*
    General queries
 */
+ (CBQuery *)withQueryConfiguration:(QueryConfiguration *)queryConfig;


/*
    Perform the query, eval the results into XCUIElements
 */
- (NSArray <XCUIElement *> *)execute;

/*
    Debug description
 */
- (NSString *)toJSONString;
@end

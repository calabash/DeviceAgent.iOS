
#import <Foundation/Foundation.h>
#import "QueryConfiguration.h"
#import "AutomationAction.h"
#import "QuerySelector.h"
#import "CBProtocols.h"
#import "CBConstants.h"
#import "XCUIElement.h"

@class CoordinateQuery;

@interface Query : AutomationAction
@property (nonatomic, strong) QueryConfiguration *queryConfiguration;

/*
    Convenience indexing into query options
 */
- (id)objectForKeyedSubscript:(NSString *)key;

/*
    Coordinate based queries
 */
@property (nonatomic) BOOL isCoordinateQuery;
- (CoordinateQuery *)asCoordinateQuery;

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

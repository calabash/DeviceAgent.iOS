
#import "ActionConfiguration.h"
#import "QuerySelector.h"

@class CoordinateQueryConfiguration;
@interface QueryConfiguration : ActionConfiguration

/*
    Array of QuerySelectors for specifying a specific element(s).
 */
@property (nonatomic, strong) NSArray <QuerySelector *> *selectors;

/*
    Coordinate queries are a special case because they don't follow the normal
    chaining logic of XCUITestQueries. They are a one-shot operation. 
 */
@property (nonatomic) BOOL isCoordinateQuery;
- (CoordinateQueryConfiguration *)asCoordinateQueryConfiguration;
@end

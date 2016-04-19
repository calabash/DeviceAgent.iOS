
#import "ActionConfiguration.h"
#import "QuerySelector.h"

/**
 A wrapper for the JSON passed to a query.
 
 These key-value pairs are validated and then used to instantiate
 an array of QuerySelectors which can be then used for evaluating a Query. 
 
 Normally, a configuration contains more semantically intuitive specifiers, such as
 `text`, `id`, `type` etc., but there is a special case of QueryConfiguration where 
 the user has specified `coordinate` or `coordinates`. There is a convenience class method,
 asCoordinateQuery, to handle this special case.
 
 See also CoordinateQueryConfiguration
 */

@class CoordinateQueryConfiguration;
@interface QueryConfiguration : ActionConfiguration

/**
 Array of QuerySelectors used for resolving to a specific element(s).
 These are generated from the initial json passed in during instatiation.
 */
@property (nonatomic, strong) NSArray <QuerySelector *> *selectors;

/**
 A convenience getter for checking if a QueryConfiguration is actually a CoordinateQueryConfiguration
 
 CoordinateQueries don't follow the normal chaining logic of XCUITestQueries
 (they are a one-shot operation). Therefore, it's helpful for a query evaluator
 to know if a Query's config indicates that it is a coordinate query.
 */
@property (nonatomic, readonly) BOOL isCoordinateQuery;

/**
 If a the current query config is in fact a coordinate query config, 
 you can convert it to it's subclass via this method. This gives you 
 compile-time validation of the Coordinate
 */
- (CoordinateQueryConfiguration *)asCoordinateQueryConfiguration;
@end

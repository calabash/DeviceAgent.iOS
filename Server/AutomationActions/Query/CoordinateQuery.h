
#import <Foundation/Foundation.h>
#import "Query.h"

@class Coordinate;

/**
A special case of Query where coordinates are explicitly specified. 
 
 **Note that
 coordinate specifiers can not be combined with any other specifiers when evaluating
 a query**.
 */
@interface CoordinateQuery : Query
/** Alias for CoordinateQueryConfiguration.coordinate */
- (Coordinate *)coordinate;
/** Alias for CoordinateQueryConfiguration.coordinates */
- (NSArray<Coordinate *> *)coordinates;
@end

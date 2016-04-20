
#import "Coordinate.h"
#import "Query.h"

/**
A special case of Query where coordinates are explicitly specified. 
 
 **Note that
 coordinate specifiers can not be combined with any other specifiers when evaluating
 a query**.
 */
@interface CoordinateQuery : Query
/** If a single `coordinate` is specified in the QueryConfiguration, 
 it will be accesible through this method */
- (Coordinate *)coordinate;
/** If a multiple `coordinates` are specified in the QueryConfiguration, 
 they will be accesible through this method */
- (NSArray<Coordinate *> *)coordinates;
@end

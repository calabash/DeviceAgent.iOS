
#import "Coordinate.h"
#import "Query.h"

@interface CoordinateQuery : Query
- (Coordinate *)coordinate;
- (NSArray<Coordinate *> *)coordinates;
@end

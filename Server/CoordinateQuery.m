
#import "CoordinateQueryConfiguration.h"
#import "CoordinateQuery.h"
#import "Coordinate.h"

@implementation CoordinateQuery

- (Coordinate *)coordinate {
    if (!self.queryConfiguration.isCoordinateQuery) {
        @throw [CBException withFormat:@"Error invoking '%@' on a non-coordinate query configuration",
                NSStringFromSelector(_cmd)];
    }
    return [self.queryConfiguration asCoordinateQueryConfiguration].coordinate;
}

- (NSArray<Coordinate *> *)coordinates {
    if (!self.queryConfiguration.isCoordinateQuery) {
        @throw [CBException withFormat:@"Error invoking '%@' on a non-coordinate query configuration",
                NSStringFromSelector(_cmd)];
    }
    return [self.queryConfiguration asCoordinateQueryConfiguration].coordinates;
}
@end


#import "CoordinateQueryConfiguration.h"
#import "CoordinateQuery.h"
#import "Coordinate.h"

@implementation CoordinateQuery

- (BOOL)isCoordinateQuery {
    return YES;
}

+ (instancetype)withQueryConfiguration:(QueryConfiguration *)queryConfig {
    if (![queryConfig isKindOfClass:[CoordinateQueryConfiguration class]]) {
        @throw [InvalidArgumentException
                withMessage:@"Attempt to instantiate coordinate query with non-coordinate config"];
    }
    CoordinateQueryConfiguration *conf = (CoordinateQueryConfiguration *)queryConfig;
    if (!(conf.coordinates || conf.coordinate)) {
        @throw [InvalidArgumentException withMessage:@"Invalid coordinate config for CoordinateQuery"
                                            userInfo:conf.raw];
    }
    return [super withQueryConfiguration:queryConfig];
}

- (Coordinate *)coordinate {
    if (!self.queryConfiguration.isCoordinateQuery) {
        @throw [CBXException withFormat:@"Error invoking '%@' on a non-coordinate query configuration",
                NSStringFromSelector(_cmd)];
    }
    return [self.queryConfiguration asCoordinateQueryConfiguration].coordinate;
}

- (NSArray<Coordinate *> *)coordinates {
    if (!self.queryConfiguration.isCoordinateQuery) {
        @throw [CBXException withFormat:@"Error invoking '%@' on a non-coordinate query configuration",
                NSStringFromSelector(_cmd)];
    }
    return [self.queryConfiguration asCoordinateQueryConfiguration].coordinates;
}
@end

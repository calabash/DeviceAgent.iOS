
#import "QueryConfiguration.h"
#import "Coordinate.h"

@interface CoordinateQueryConfiguration : QueryConfiguration
@property (nonatomic, strong) Coordinate *coordinate;
@property (nonatomic, strong) NSArray <Coordinate *> *coordinates;
@end

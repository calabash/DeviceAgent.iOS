
#import "QueryConfiguration.h"
#import "Coordinate.h"

/**
 A special case of QueryConfiguration where the element
 is specified directly via coordinates.
 
 This is a common use case for Gestures, since Gestures ultimately operate on coordinates.
 */

@interface CoordinateQueryConfiguration : QueryConfiguration
@property (nonatomic, strong) Coordinate *coordinate;
@property (nonatomic, strong) NSArray <Coordinate *> *coordinates;
@end


#import "QueryConfiguration.h"
#import "Coordinate.h"

/**
 A special case of QueryConfiguration where the element
 is specified directly via coordinates.
 
 This is a common use case for Gestures, since Gestures ultimately operate on coordinates.
 
 Note that you can not specify both `coordinate` and `coordinates` in the configuration, so
 only one of coordinate or coordinates can ever return a non-nil value.
 */

@interface CoordinateQueryConfiguration : QueryConfiguration

/**If a single coordinate is specified for the Gesture, it will be accessible here*/
@property (nonatomic, strong) Coordinate *coordinate;

/**If multiple coordinates were specified for the Gesture, they will be accessible here*/
@property (nonatomic, strong) NSArray <Coordinate *> *coordinates;
@end

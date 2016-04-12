
#import "Coordinate.h"
#import "JSONUtils.h"

@interface Coordinate()
@property (nonatomic, strong) id json;
@end

@implementation Coordinate
- (CGPoint)cgpoint {
    return [JSONUtils pointFromCoordinateJSON:self.json];
}

+ (instancetype)fromRaw:(CGPoint)raw {
    return [self withJSON:@[ @(raw.x), @(raw.y) ]];
}

+ (instancetype)withJSON:(id)json {
    Coordinate *coord = [self new];
    [JSONUtils validatePointJSON:json];
    coord.json = json;
    return coord;
}

- (NSString *)description {
    CGPoint p = [self cgpoint];
    return [NSString stringWithFormat:@"(%f, %f)", p.x, p.y];
}
@end


#import "CoordinateQueryConfiguration.h"
#import "JSONUtils.h"

@implementation CoordinateQueryConfiguration
@synthesize isCoordinateQuery = _isCoordinateQuery;

- (id)init {
    if (self = [super init]) {
        _isCoordinateQuery = YES;
    }
    return self;
}

- (BOOL)isCoordinateQuery {
    return YES;
}

- (void)validate {
    if (self.raw[CBX_COORDINATE_KEY]) {
        id json = self.raw[CBX_COORDINATE_KEY];
        [JSONUtils validatePointJSON:json];
        self.coordinate = [Coordinate withJSON:json];
    }
    
    if (self.raw[CBX_COORDINATES_KEY]) {
        NSMutableArray *coords = [NSMutableArray array];
        for (id json in self.raw[CBX_COORDINATES_KEY]) {
            [JSONUtils validatePointJSON:json];
            [coords addObject:[Coordinate withJSON:json]];
        }
        self.coordinates = coords;
    }
    
    if (!self.coordinate && !self.coordinates) {
        @throw [InvalidArgumentException withMessage:@"Unable to create coordinate config from json"
                                            userInfo:self.raw];
    }
    
    if (self.coordinate && self.coordinates) {
        @throw [InvalidArgumentException withMessage:@"Can not supply both 'coordinate' and 'coordinates'"
                                            userInfo:self.raw];
    }
}

+ (instancetype)withJSON:(NSDictionary *)json validator:(JSONKeyValidator *)validator {
    CoordinateQueryConfiguration *config = [super withJSON:json validator:validator];
    [config validate];
    return config;
}
@end

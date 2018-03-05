
#import "CoordinateQueryConfiguration.h"
#import "JSONUtils.h"
#import "CBXConstants.h"
#import "InvalidArgumentException.h"
#import "Coordinate.h"

@implementation CoordinateQueryConfiguration

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


#import "QueryConfigurationFactory.h"

#import "QueryConfiguration.h"
#import "CoordinateQueryConfiguration.h"

@implementation QueryConfigurationFactory
+ (QueryConfiguration *)configWithJSON:(NSDictionary *)json
                             validator:(JSONKeyValidator *)validator {
    for (NSString *key in json) {
        /*
         If there are any keys which indicate coordinates, then we treat the object
         as a CoordinateQueryConfiguration
         */
        if ([key isEqualToString:CBX_COORDINATE_KEY] ||
            [key isEqualToString:CBX_COORDINATES_KEY]) {
            return [CoordinateQueryConfiguration withJSON:json validator:validator];
        }
    }
    return [QueryConfiguration withJSON:json validator:validator];
}
@end


#import "InvalidArgumentException.h"
#import "ActionConfiguration.h"
#import "CBXException.h"
#import "CBMacros.h"

@implementation ActionConfiguration

+ (instancetype)withJSON:(NSDictionary *)json {
    ActionConfiguration *config = [self new];
    config.raw = json;
    return config;
}

- (id)objectForKeyedSubscript:(NSString *)key {
    return self.raw[key];
}

+ (instancetype)withJSON:(NSDictionary *)json
               validator:(JSONKeyValidator *)validator {
    [validator validate:json];
    return [self withJSON:json];
}

@end

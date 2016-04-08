
#import "CBInvalidArgumentException.h"
#import "ActionConfiguration.h"
#import "CBException.h"
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

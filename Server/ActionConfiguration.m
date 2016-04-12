
#import "InvalidArgumentException.h"
#import "ActionConfiguration.h"
#import "CBXException.h"
#import "CBXMacros.h"

@implementation ActionConfiguration

+ (instancetype)withJSON:(NSDictionary *)json {
    ActionConfiguration *config = [self new];
    config.raw = json;
    return config;
}

- (id)objectForKeyedSubscript:(NSString *)key {
    return self.raw[key];
}

- (BOOL)has:(NSString *)key {
    return [[self.raw allKeys] containsObject:key];
}

+ (instancetype)withJSON:(NSDictionary *)json
               validator:(JSONKeyValidator *)validator {
    [validator validate:json];
    return [self withJSON:json];
}

@end

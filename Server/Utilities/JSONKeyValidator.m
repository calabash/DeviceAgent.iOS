//
//  JSONActionValidator.m
//  CBXDriver
//
//  Created by Chris Fuentes on 4/6/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBInvalidArgumentException.h"
#import "JSONKeyValidator.h"

@implementation JSONKeyValidator
NS_ASSUME_NONNULL_BEGIN
- (id)initWithRequiredKeys:(NSArray <NSString *> *)requiredKeys
              optionalKeys:(NSArray <NSString *> *)optionalKeys {
    if (self = [super init]) {
        _requiredKeys = requiredKeys;
        _optionalKeys = optionalKeys;
    }
    return self;
}
+ (instancetype)withRequiredKeys:(NSArray <NSString *> *)requiredKeys
                    optionalKeys:(NSArray <NSString *> *)optionalKeys {
    return [[self alloc] initWithRequiredKeys:requiredKeys optionalKeys:optionalKeys];
}

- (void)validate:(NSDictionary *)json {
    NSArray *keys = [json allKeys];
    
    /*
     Ensure that every key is supported in some manner
     */
    for (NSString *k in keys) {
        if (!([self.requiredKeys containsObject:k] ||
              [self.optionalKeys containsObject:k] )) {
            @throw [CBInvalidArgumentException withFormat:@"Unsupported key: '%@'", k];
        }
    }
    
    /*
     Ensure that all required keys are present in the json
     */
    for (NSString *key in self.requiredKeys) {
        if (![keys containsObject:key]) {
            @throw [CBInvalidArgumentException withFormat:@"Required key '%@' is missing.", key];
        }
    }
}
NS_ASSUME_NONNULL_END
@end

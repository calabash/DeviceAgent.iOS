//
//  ActionConfiguration.m
//  CBXDriver
//
//  Created by Chris Fuentes on 4/5/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

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
               validator:(JSONActionValidator *)validator {
    [validator validate:json];
    return [self withJSON:json];
}

@end

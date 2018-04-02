
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import <Foundation/Foundation.h>
#import "JSONKeyValidator.h"

/** A generic object for encapsulating the various key-value pairs passed to 
 an AutomationAction. 
 
 The ActionConfiguration object is responsible for storing the options to be 
 passed to an AutomationAction as well as perform validation on those options.
 
 See also GestureConfiguration and QueryConfiguration
 */

@interface ActionConfiguration : NSObject

- (id)objectForKeyedSubscript:(NSString *)key;

/**
 Creates a configuration object and validates the json inputs against
 required/optional specifiers.
 
 @param json object containing action options
 @param validator a validator to use with the json
 @return A new, validated ActionConfiguration.
 @exception InvalidArgumentException The json does not validate with the validator, or
 there are both a `coordinate` and `coordinates` key.
 */
+ (instancetype)withJSON:(NSDictionary *)json
               validator:(JSONKeyValidator *)validator;

/**
 Checks if a given key exists. 
 
 @param key Key to check
 @return YES if the key exists in the raw json.
 */
- (BOOL)has:(NSString *)key;

/**
 The original JSON input to the ActionConfiguration.
 */
@property (nonatomic, readonly) NSDictionary *raw;

@end

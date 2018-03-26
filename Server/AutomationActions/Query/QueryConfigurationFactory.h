
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import <Foundation/Foundation.h>

@class QueryConfiguration;
@class JSONKeyValidator;

/**
 Simple factory class for creating QueryConfiguration objects.
 */
@interface QueryConfigurationFactory : NSObject

/**
 Basic static factory constructor for creating a QueryConfiguration.
 
 **This should be used instead of direct instantiation, unless you're sure you know
 which class you want to instantiate.**
 
 @param json Raw key-value pairs which comprise the query configuration
 @param validator Used to validate the `json` input
 @return QueryConfiguration or CoordinateQueryConfiguration as appropriate, based on `json` input
 */
+ (QueryConfiguration *)configWithJSON:(NSDictionary *)json
                             validator:(JSONKeyValidator *)validator;
@end


// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import <Foundation/Foundation.h>

/**
 An object that validates the presence or absence of keys in
 a json object.
 */
@interface JSONKeyValidator : NSObject
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, readonly) NSArray <NSString *> *requiredKeys;
@property (nonatomic, readonly) NSArray <NSString *> *optionalKeys;

/**
Convenience constructor
 @param requiredKeys  Keys which the json **must** contain
 @param optionalKeys Keys which the json **may** contain
 */
+ (instancetype)withRequiredKeys:(NSArray <NSString *> *)requiredKeys
                    optionalKeys:(NSArray <NSString *> *)optionalKeys;

/**
Validates that `json` contains all of `requiredKeys` and
contains only keys that are either listed in `requiredKeys` or `optionalKeys`. 
 
 The purpose is to ensure that any required keys are found and 
 that any optional keys are actually supported. 
 
 @param json The JSON object to validate
 */
- (void)validate:(NSDictionary *)json;
NS_ASSUME_NONNULL_END
@end

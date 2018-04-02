
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import <Foundation/Foundation.h>
#import "CoordinateQuery.h"

/**
 A simple factory class for creating Query objects.
 */
@interface QueryFactory : NSObject
/**
 Basic static factory constructor for creating a Query object.
 
 **This should be used instead of direct instantiation, unless you're sure you know
 which class you want to instantiate.**
 
 @param queryConfig A QueryConfiguration or CoordinateQueryConfiguration
 @return Query or CoordinateQuery as appropriate, based on `queryConfig`
 */
+ (Query *_Nonnull)queryWithQueryConfiguration:(QueryConfiguration *_Nonnull)queryConfig;
@end

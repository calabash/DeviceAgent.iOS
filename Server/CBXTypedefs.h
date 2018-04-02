
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#ifndef CBXTypedefs_h
#define CBXTypedefs_h

#import <Foundation/Foundation.h>

/**
    Generic completion block with a nullable NSError * param
 */
typedef void (^CompletionBlock)(NSError *e);
/**
    Generic block, no params, no return
 */
typedef void (^Block)(void);

/**
    A block intended to be used in an async context.
    The BOOL * param should be set to YES when the async
    functionality is complete (or whenever it's "done enough").
 */
typedef void (^AsyncBlock)(BOOL *setToTrueWhenDone);

#endif /* CBXTypedefs_h */

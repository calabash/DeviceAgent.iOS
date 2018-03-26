
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import <Foundation/Foundation.h>
#import "QuerySpecifier.h"

/**
 Given some prior results, specify which index of those results you want. 
 Note that this still returns an NSArray of XCUIElements.
 
 ## Usage:
 
 { "index" : Number }
 
 */
@interface QuerySpecifierByIndex : QuerySpecifier<QuerySpecifier>

@end

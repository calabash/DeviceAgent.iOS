
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import <Foundation/Foundation.h>
#import "QuerySpecifier.h"

/**
 Specify elements by `id`. Seems to correspond to the original UIViews'
    `accessibilityIdentifier`. 
 

## Usage:
 
    { "id" : String }
 
 */
@interface QuerySpecifierById : QuerySpecifier<QuerySpecifier>

@end

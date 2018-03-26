
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import <Foundation/Foundation.h>
#import "QuerySpecifierByProperty.h"

/**
 As QuerySpecifierByProperty, but with case- and diacritical-insensitive search.
 
 See QuerySpecifierByProperty.
 
 ## Usage:
 
 { "property_like" : "<key>=<value>" }
 OR
 { "property_like" : { <key|property|using> : String, "value" : String } }
 
 */

@interface QuerySpecifierByPropertyLike : QuerySpecifierByProperty <QuerySpecifier>

@end


// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import <Foundation/Foundation.h>
#import "QuerySpecifierByText.h"

/**
 Specify elements by text using case- and diacritical-insensitive match. 
 
 See QuerySpecifierText
 
 ## Usage:
 
 { "text_like" : "String" }
 */

@interface QuerySpecifierByTextLike : QuerySpecifierByText<QuerySpecifier>

@end

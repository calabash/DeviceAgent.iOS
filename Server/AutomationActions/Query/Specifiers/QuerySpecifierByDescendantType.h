
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import <Foundation/Foundation.h>
#import "QuerySpecifier.h"

/**
 This specifier finds all descendants elements matching the descendant_type within the element matching the parent_type.
 
 ## Usage:
 
 { "descendant_element" : { "parent_type": "String", "descendant_type": "String" } }
 */
@interface QuerySpecifierByDescendantType : QuerySpecifier<QuerySpecifier>
@end


// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import <Foundation/Foundation.h>
#import "QuerySpecifier.h"

/**
 Specify elements by `id`, `label`, `value`, and `text`.

 ## Usage:

 { "marked" : String }

 */
@interface QuerySpecifierByMark : QuerySpecifier<QuerySpecifier>

@end

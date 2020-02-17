
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import <Foundation/Foundation.h>
#import "QuerySpecifier.h"

/**
 Specify elements by matchingPredicate (see XCUIElementQuery.h for all predicate methods).
 
 The predicate will be evaluated against objects of type id<XCUIElementAttributes>.
 
 This specifier matches any elements belonging to the provided predicate.
 
 ## Usage:
 
 { "predicate_string" : "label MATCHES '(Safari|News)' AND elementType == 'StaticText'" }
 */
@interface QuerySpecifierByPredicate : QuerySpecifier<QuerySpecifier>
@end

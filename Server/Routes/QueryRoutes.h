
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import <Foundation/Foundation.h>
#import "CBXProtocols.h"

/**
 Routes for querying for elements in the application's view hierarchy.

 ## GET @"/1.0/tree"
 Returns a JSON tree of the application with the XCUIApplication object
 as the root object.

 ## POST @"/1.0/query"
    {
        key: val
    }

 The JSON body should contain QuerySpecifier key-value pairs. See QuerySpecifier.
 This also corresponds to the `specifiers` field in a Gesture. See GestureRoutes.

 ## GET @"/springboard-alert"

 Responds with a JSON representation of any visible SpringBoard alert. Responds
 with an empty dictionary if there is no SpringBoard alert.

 ## GET @"/orientations"

 Responds with information about device and application orientations.

 ## GET @"/element-types"

 Responds with a JSON list of XCTest.framework element types as human-readable
 strings.

 */
@interface QueryRoutes : NSObject<CBRouteProvider>

@end

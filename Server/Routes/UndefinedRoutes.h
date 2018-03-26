
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import <Foundation/Foundation.h>
#import "CBXProtocols.h"

/**
 Route handlers for undefined endpoints. 
 
 These contain match-all regexes so that any request which isn't matched
 to another route will fall to an undefined route, which returns an error message
 to the user. 
 
 Because these use match-all regexes, we can not risk them being
 added to the server before any other route, thus the implementation makes use
 of the `shouldAutoregister` property of CBXRoute.
 
 See CBXRoute
 */
@interface UndefinedRoutes : NSObject<CBRouteProvider>
@end

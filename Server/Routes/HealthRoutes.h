
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import "CBXProtocols.h"

/**
 Routes used to determine if the server is running. 
 
 ## GET @"/health"
 Should return a friendly message if the server is running. 
 
 ## GET @"/ping"
 Duplicate functionality
 Should return a friendly message if the server is running.
 */
@interface HealthRoutes : NSObject<CBRouteProvider>
@end

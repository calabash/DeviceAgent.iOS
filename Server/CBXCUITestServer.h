
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import <Foundation/Foundation.h>

/**
 HTTP routing server
 */
@interface CBXCUITestServer : NSObject
/**
 Starts the server on the default port
 */
+ (void)start;  //Calabus driver, start your engine!

/**
 Stops the server
 */
+ (void)stop;   //Come to a complete (non-rolling) stop.
@end

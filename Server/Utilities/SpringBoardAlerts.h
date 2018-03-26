
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import <Foundation/Foundation.h>

@class SpringBoardAlert;

/**
 * An interface to the SpringBoard alerts that can be dismissed automatically.
 *
 * This is a singleton class.  Calling `init` will raise an exception.
 */
@interface SpringBoardAlerts : NSObject

/**
 * A singleton for reasoning about SpringBoard alerts
 *
 * @return the SpringBoardAlerts instance.
 */
+ (SpringBoardAlerts *)shared;

/**
 * Returns a SpringBoardAlert if the the alertTitle matches one of the known
 * alerts. If the alert title matches no known alert, this method returns nil.
 * @param alertTitle The title of the alert; alert.label
 * @return a SpringBoardAlert or nil
 */
- (SpringBoardAlert *)alertMatchingTitle:(NSString *)alertTitle;

@end

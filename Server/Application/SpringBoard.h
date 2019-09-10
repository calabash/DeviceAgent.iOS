
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Foundation/Foundation.h>
#import "CBX-XCTest-Umbrella.h"
#import "XCTest+CBXAdditions.h"

// Experimental
// This enum describes the success or failure of the
// dismissAlertByTappingAlertButtonWithTitle
typedef enum : NSUInteger {
    SpringBoardDismissAlertDismissedAlert = 0,
    SpringBoardDismissAlertNoAlert,
    SpringBoardDismissAlertNoMatchingButton,
    SpringBoardDismissAlertDismissTouchFailed
} SpringBoardDismissAlertResult;

@interface SpringBoard : XCUIApplication

/**
 Controls whether or not SpringBoard alerts are dismissed automatically or
 manually.  The default is to dismiss alerts automatically by accepting or
 allowing a privacy alert.  Other alerts, like the no SIM detected alert,
 are dismissed by touching the least disruptive (to testing) button.

 */
@property (atomic, assign) BOOL shouldDismissAlertsAutomatically;

/**
 @return The XCUIApplication that is attached to SpringBoard
 */
+ (instancetype)application;

/**
 Query for alerts presented by SpringBoard.

 @return An alert if one is visible and nil otherwise.
 */
- (XCUIElement *)queryForAlert;

/**
 Alerts presented by SpringBoard block automation.  This method tries to automatically
 dismiss alerts by matching the alert title against a set of known alert titles.

 This method polls until there is no alert or an unrecognized is showing.  This is
 necessary to handle apps that present multiple alerts at launch.

 This method is designed to be called before every /query, /tree, or /gesture call.

 This method does not call #dismissAlertByTappingButtonTitle:

 @see SpringBoardAlerts

 @exception SpringBoardAlertHandlerException To avoid an infinite loop, this method will
 raise an exception if it cannot dismiss the alert after number of tries.

 */
- (void)handleAlertsOrThrow;

/**
 Attempts to dismiss a SpringBoard alert by tapping a specific button.

 The SpringBoardDismissAlertResult enum describes the possible outcomes.

 * SpringBoardDismissAlertDismissedAlert - the alert was dismissed
 * SpringBoardDismissAlertNoAlert - there was no alert
 * SpringBoardDismissAlertNoMatchingButton - there was an alert, but no button with title
 * SpringBoardDismissAlertDismissTouchFailed - the button touch failed

 These values are provided so the caller decide the best possible action and compose a
 meaningful error message.

 @param title the text of the button
 @return SpringBoardDismissAlertResult describes possible outcomes of the gesture.
 */
- (SpringBoardDismissAlertResult)dismissAlertByTappingButtonWithTitle:(NSString *)title;

- (XCUIElement *)findDismissButtonOnAlert:(XCUIElement *)alert marks: (NSArray *)marks;

@end

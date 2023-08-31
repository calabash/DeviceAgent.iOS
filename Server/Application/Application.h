
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>
#import "XCTest+CBXAdditions.h"

@class XCUIApplication;

/**
 DeviceAgent wrapper class for XCUIApplication
 */
@interface Application : NSObject
/**
 Convenience method to launch an app. Sets the launched app as the `currentApplication`

 @param bundleId identifier of the app to launch
 @param launchArgs Arguments to pass to the application upon launch.
 @param environment Key-value dict of environment variables to pass to the app upon launch.
 @param terminateIfRunning If true and the application with bundle id is running,
 then DeviceAgent will terminate the app before relaunching.
 */
+ (void)launchAppWithBundleId:(NSString *_Nullable)bundleId
                   launchArgs:(NSArray *_Nullable)launchArgs
                    launchEnv:(NSDictionary *_Nullable)environment
           terminateIfRunning:(BOOL)terminateIfRunning;

/**A reference to the currently running application. */
+ (XCUIApplication *_Nonnull)currentApplication;

/**
 Attempt to terminate the current application.
 @return the XCUIApplicationState
 */
+ (XCUIApplicationState)terminateCurrentApplication;

/**
 Terminate the application with bundle identifier.

 @param bundleIdentifier app to terminate
 @return the XCUIApplicationState
 */
+ (XCUIApplicationState)terminateApplicationWithIdentifier:(NSString *_Nullable)bundleIdentifier;

/**
 Terminate the application.

 @param application The application to terminate
 @return the XCUIApplicationState
 */
+ (XCUIApplicationState)terminateApplication:(XCUIApplication *_Nullable)application;

/**
 Returns a tree representation of the application view hierarchy.

 @return a dictionary of views.
 */
+ (NSDictionary *_Nonnull)tree;

+ (void)setPickerWheelValue:(int)pickerIndex wheelIndex:(int)wheelIndex value:(NSString *_Nonnull)value;

@end

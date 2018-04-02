
#import <Foundation/Foundation.h>

#ifndef __IPHONE_11_0
typedef NS_ENUM(NSUInteger, XCUIApplicationState) {
    XCUIApplicationStateUnknown = 0,
    XCUIApplicationStateNotRunning = 1,
#if !TARGET_OS_OSX
    XCUIApplicationStateRunningBackgroundSuspended = 2,
#endif
    XCUIApplicationStateRunningBackground = 3,
    XCUIApplicationStateRunningForeground = 4
};
#endif

@class XCUIApplication;

@interface ACTLaunch : NSObject

+ (XCUIApplication *)launch;
+ (XCUIApplication *)launchApplication:(XCUIApplication *)application;

// Objective-C only
#define act_launch [ACTLaunch launch];
#define act_launch_app(application) [ACTLaunch launchApplication:application]

// Swift Usage
// launchApplication will be renamed to launch(_:)
// ACTLaunch.launch => XCUIApplication
// ACTLaunch.launch(XCUIApplication()) => XCUIApplication

@end


#import <UIKit/UIKit.h>

/**
 A collection of methods for discovering and changing the device orientation.

 UIInterfaceOrientation values are normalized to UIDeviceInterface values.

 Orientations are defined by the location of the home button relative to the
 status bar.

 For example, UIDeviceOrientationLandscapeLeft means the home button is on the left
 relative to the status bar.
 */
@interface CBXOrientation : NSObject

/**
 Translates an interface orientation to a human readable string.

 The orientation can be a UIInterfaceOrientation or UIDeviceOrientation.

 If orientation is not an interface or device orientation, this method returns the
 empty string.

 @param orientation the orientation to translate.
 @return an NSString
 */
+ (NSString *)stringForOrientation:(NSUInteger)orientation;

/**
 Translates a human readable string to a UIDeviceOrientation.

 @param string the string to translate.
 @return a UIDeviceOrientation
 @throw CBXException if string is not a recognized orientation.
 */
+ (UIDeviceOrientation)orientationForString:(NSString *)string;

/**
 The orientation of the device reported by UIDevice#orientation.

 @return a UIDeviceOrientation
 */
+ (UIDeviceOrientation)UIDeviceOrientation;

/**
 The orientation of the device reported by XCUIDevice#orientation
 @return a UIDeviceOrientation
 */
+ (UIDeviceOrientation)XCUIDeviceOrientation;

/**
 The orientation of the device reported by XCUIApplication#interfaceOrientation

 The UIInterfaceOrientation is converted to a UIDeviceOrientation.

 @return a UIDeviceOrientation
 */
+ (UIDeviceOrientation)AUTOrientation;

/**
 The orientation of the device reported by SpringBoard#interfaceOrientation

 The UIInterfaceOrientation is converted to a UIDeviceOrientation.

 @return a UIDeviceOrientation
 */
+ (UIDeviceOrientation)SpringBoardOrientation;

/**
 Information about device and application orientations.

 @return an NSDictionary
 */
+ (NSDictionary *)orientations;

/**
 If the topmost app does not respond to the new orientation, the rotation will
 appear to have no effect.

 @param orientation the new orientation
 @param secondsToSleepAfter how long to wait after changing the orientation
 */
+ (void)setOrientation:(UIDeviceOrientation)orientation
   secondsToSleepAfter:(NSTimeInterval)secondsToSleepAfter;

@end

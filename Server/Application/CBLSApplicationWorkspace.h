
#import <Foundation/Foundation.h>

/**
 * Wrapper around private LSApplicationWorkspace.
 *
 * This class is for debugging.
 *
 * Starting in Xcode 9/iOS 11, interacting with LS private classes has been
 * unsatisifying.
 */
@interface CBLSApplicationWorkspace : NSObject

/**
 * Returns YES if an application with bundle identifier is installed on the
 * target device.
 *
 * @param bundleIdentifier The application identifier to look for.
 *
 * @return YES if an application with bundleIdentifier is installed.
 */
+ (BOOL)applicationIsInstalled:(NSString *)bundleIdentifier;

@end

#import <Foundation/Foundation.h>

/**
 An interface to the application stub's Info.plist.
 */
@interface CBXInfoPlist : NSObject

/**
 Returns the CFBundleName.
 */
- (NSString *)bundleName;

/**
 Returns the CFBundleIdentifier.
 */
- (NSString *)bundleIdentifier;

/**
 Returns the CFBundleVersion - the build version.
 */
- (NSString *)bundleVersion;

/**
 Returns the CFBundleShortVersionString - the marketing version.
 */
- (NSString *)bundleShortVersion;

/**
 * Returns the DTPlatformVersion - the iOS SDK Version
 */
- (NSString *)platformVersion;

/**
 * Returns the DTXcode - the version of Xcode used to build DeviceAgent
 */
- (NSString *)xcodeVersion;

/**
 * Returns the MinimumOSVersion - iOS Deployment Target
 */
- (NSString *)minimumOSVersion;

/**
 Returns a dictionary of version information.
 */
- (NSDictionary *)versionInfo;

@end

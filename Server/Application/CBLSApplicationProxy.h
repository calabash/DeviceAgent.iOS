#import <Foundation/Foundation.h>

/**
 * A wrapper around private LSApplicationProxy class.
 */
@interface CBLSApplicationProxy : NSObject

/**
 * Returns a wrapper around an LSApplicationProxy instance.
 * @param bundleIdentifier the bundle id
 * @return An object with a reference to CBLSApplicationProxy instance.  If no
 *   application proxy can be found, this method returns nil.
 */
+ (CBLSApplicationProxy *)applicationProxyForIdentifier:(NSString *)bundleIdentifier;

/**
 * The localized display name as specified in the application's Info.plist by
 * the CFBundleDisplayName key.
 *
 * @return  If the LSApplicationProxy instance is nil or there is problem
 * calling the localizedName method on the instance, this method returns nil.
 */
- (NSString *)localizedName;

/**
 * A file URL pointing to the directory where the bundle is installed.
 *
 * @return an NSURL
 */
- (NSURL *)bundleURL;

@end

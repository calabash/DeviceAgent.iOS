
#import <Foundation/Foundation.h>

@class SpringboardAlert;

/**
 * An interface to the iOS Privacy Alerts that can be dismissed automatically.
 *
 * This is a singleton class.  Calling `init` will raise an exception.
 */
@interface SpringboardAlerts : NSObject

/**
 * A singleton for reasoning about iOS Privacy Alerts
 *
 * @return the PrivacyAlerts instance.
 */
+ (SpringboardAlerts *)shared;

/**
 * Returns a SpringboardAlert if the the alertTitle matches one of the known
 * alerts. If the alert title matches no known alert, this method returns nil.
 * @param alertTitle The title of the alert; alert.label
 * @return a SpringboardAlert or nil
 */
- (SpringboardAlert *)springboardAlertForAlertTitle:(NSString *)alertTitle;

@end

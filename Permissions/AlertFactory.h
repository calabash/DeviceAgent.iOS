
#import <Foundation/Foundation.h>

@class UIViewController;
@class UIAlertController;

@interface AlertFactory : NSObject

@property(strong, nonatomic) UIViewController *controller;

- (id)initWithViewController:(UIViewController *)controller;

- (UIAlertController *)alertForFacebookNYI;
- (UIAlertController *)alertForHomeKitNYI;
- (UIAlertController *)alertForHealthKitNotSupported;
- (UIAlertController *)alertForBluetoothFAKE;

@end

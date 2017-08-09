
#import "AlertFactory.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>

static NSString *const CBXDeviceSimKeyModelIdentifier = @"SIMULATOR_MODEL_IDENTIFIER";

@interface AlertFactory ()

@property(copy, nonatomic, readonly) NSString *localizedDismiss;

- (UIAlertController *)alertForNYIWithMessage:(NSString *)message;
- (UIAlertController *)alertForNotSupportedWithServiceName:(NSString *)serviceName;

- (NSString *)facebookMessage;
- (NSString *)homeKitMessage;
- (NSString *)healthKitMessage;

@end

@implementation AlertFactory

@synthesize localizedDismiss = _localizedDismiss;

- (NSString *)simulatorVersionInfo {
    NSDictionary *env = [[NSProcessInfo processInfo] environment];
    return env[CBXDeviceSimKeyModelIdentifier];
}

- (NSString *)physicalDeviceModelIdentifier {
    struct utsname systemInfo;
    uname(&systemInfo);
    return @(systemInfo.machine);
}

- (NSString *)modelIdentifier {
    NSString *model = [self simulatorVersionInfo];
    if (model) {
        return model;
    } else {
        return [self physicalDeviceModelIdentifier];
    }
}

- (id)initWithViewController:(UIViewController *)controller {
    self = [super init];
    if (self) {
        _controller = controller;
    }
    return self;
}

- (NSString *)localizedDismiss {
    if (_localizedDismiss) { return _localizedDismiss; }

    _localizedDismiss = NSLocalizedString(@"Dismiss",
                                          @"Alert button title: touching dismissing the alert with no consequences");
    return _localizedDismiss;
}

- (NSString *) facebookMessage {
    return NSLocalizedString(@"Testing Facebook permissions has not been implemented.",
                             @"Alert message");
}

- (NSString *)homeKitMessage {
    return NSLocalizedString(@"Testing Home Kit permissions has not been implemented.",
                             @"Alert message");
}

- (NSString *)healthKitMessage {
    return NSLocalizedString(@"Testing Health Kit permissions has not been implemented.",
                             @"Alert message");
}

- (UIAlertController *)alertForNYIWithMessage:(NSString *) message {
    NSString *title = NSLocalizedString(@"Not Implemented",
                                        @"Alert title: feature is not implemented yet");

    __weak typeof(self.controller) wController = self.controller;
    void (^handler)(UIAlertAction *) = ^void(UIAlertAction *action) {
        [wController dismissViewControllerAnimated:YES completion:nil];
    };


    UIAlertController *controller;
    controller = [UIAlertController alertControllerWithTitle:title
                                                     message:message
                                              preferredStyle:UIAlertControllerStyleAlert];

    [controller addAction:[UIAlertAction actionWithTitle:@"OK"
                                                   style:UIAlertActionStyleDefault
                                                 handler:handler]];

    [controller addAction:[UIAlertAction actionWithTitle:self.localizedDismiss
                                                   style:UIAlertActionStyleCancel
                                                 handler:handler]];
    return controller;
}

- (UIAlertController *)alertForNotSupportedWithServiceName:(NSString *) serviceName {
    NSString *title = @"Not Supported";

    NSString *version = [[UIDevice currentDevice] systemVersion];
    NSString *model = [self modelIdentifier];
    NSString *message = [NSString stringWithFormat:@"%@ is not supported on iOS %@ and/or this device model: %@.",
                         serviceName, version, model];

    __weak typeof(self.controller) wController = self.controller;
    void (^handler)(UIAlertAction *) = ^void(UIAlertAction *action) {
        [wController dismissViewControllerAnimated:YES completion:nil];
    };

    UIAlertController *controller;
    controller = [UIAlertController alertControllerWithTitle:title
                                                     message:message
                                              preferredStyle:UIAlertControllerStyleAlert];

    [controller addAction:[UIAlertAction actionWithTitle:@"OK"
                                                   style:UIAlertActionStyleDefault
                                                 handler:handler]];

    [controller addAction:[UIAlertAction actionWithTitle:self.localizedDismiss
                                                   style:UIAlertActionStyleCancel
                                                 handler:handler]];
    return controller;
}

- (UIAlertController *)alertForFacebookNYI {
    return [self alertForNYIWithMessage:[self facebookMessage]];
}

- (UIAlertController *) alertForHomeKitNYI {
    return [self alertForNYIWithMessage:[self homeKitMessage]];
}

- (UIAlertController *) alertForHealthKitNotSupported {
    return [self alertForNotSupportedWithServiceName:@"HealthKit"];
}

// We have not been able to generate a Bluetooth alert, but we have one example
// in English.
- (UIAlertController *) alertForBluetoothFAKE {
    NSString *title = @"APP NAME would like to make data available to nearby bluetooth devices even when you're not using the app";
    NSString *no = @"Don't Allow";
    NSString *ok = @"OK";

    __weak typeof(self.controller) wController = self.controller;
    void (^handler)(UIAlertAction *) = ^void(UIAlertAction *action) {
        [wController dismissViewControllerAnimated:YES completion:nil];
    };

    UIAlertController *controller;
    controller = [UIAlertController alertControllerWithTitle:title
                                                     message:@""
                                              preferredStyle:UIAlertControllerStyleAlert];

    [controller addAction:[UIAlertAction actionWithTitle:ok
                                                   style:UIAlertActionStyleDefault
                                                 handler:handler]];

    [controller addAction:[UIAlertAction actionWithTitle:no
                                                   style:UIAlertActionStyleCancel
                                                 handler:handler]];
    return controller;
}

@end

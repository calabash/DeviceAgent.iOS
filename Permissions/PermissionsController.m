
@import EventKit;
@import AVFoundation;
@import CoreBluetooth;
@import CoreMotion;
@import Accounts;
@import UserNotifications;

#import "PermissionsController.h"
#import "AlertFactory.h"
#import <objc/runtime.h>
#import <HealthKit/HealthKit.h>
#import <Contacts/Contacts.h>

@interface UIView (CalabashBackdoor)

- (BOOL)isHealthKitAvailable;

@end

@implementation UIView (CalabashBackdoor)

// HealthKit is available on iOS > 7 and only on some devices
- (BOOL)isHealthKitAvailable {
    return NSClassFromString(@"HKHealthStore") && [HKHealthStore isHealthDataAvailable];
}

@end

typedef enum : NSInteger {
    kRowLocationServices = 0,
    kRowBackgroundLocationServices,
    kRowContacts,
    kRowCalendars,
    kRowReminders,
    kRowPhotos,
    kRowBlueTooth,
    kRowMicrophone,
    kRowMotionActivity,
    kRowCamera,
    kFacebook,
    kTwitter,
    kHomeKit,
    kHealthKit,
    kAPNS,
    kNumberOfRows
} CalTableRows;


@interface PermissionsController ()

@property(strong, nonatomic) CLLocationManager *locationManager;
@property(strong, nonatomic) EKEventStore *eventStore;
@property(strong, nonatomic) UIImagePickerController *picker;
@property(strong, nonatomic) CBCentralManager *cbManager;
@property(strong, nonatomic) CMMotionActivityManager *cmManger;
@property(strong, nonatomic) NSOperationQueue* motionActivityQueue;
@property(strong, nonatomic) ACAccountStore *accountStore;
@property(strong, nonatomic, readonly) AlertFactory *alertFactory;

- (void)rowTouchedLocationServices;
- (void)rowTouchedBackgroundLocationServices;
- (void)rowTouchedContacts;
- (void)rowTouchedCalendars;
- (void)rowTouchedReminders;
- (void)rowTouchedPhotos;
- (void)rowTouchedBluetooth;
- (void)rowTouchedMicrophone;
- (void)rowTouchedMotionActivity;
- (void)rowTouchedCamera;
- (void)rowTouchedFacebook;
- (void)rowTouchedTwitter;
- (void)rowTouchedHomeKit;
- (void)rowTouchedHealthKit;
- (void)rowTouchedApns;

@end

@implementation PermissionsController

#pragma mark - Memory Management

@synthesize alertFactory = _alertFactory;

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (AlertFactory *)alertFactory {
    if (_alertFactory) { return _alertFactory; }
    _alertFactory = [[AlertFactory alloc] initWithViewController:self];
    return _alertFactory;
}

#pragma mark - Row Touched: Location Services

- (void)rowTouchedLocationServices {
    NSLog(@"Location Services requested");

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    SEL authorizationSelector = @selector(requestWhenInUseAuthorization);
    if ([self.locationManager respondsToSelector:authorizationSelector]) {
        NSLog(@"Requesting when-in-use authorization");
        [self.locationManager requestWhenInUseAuthorization];
    } else {
        if ([CLLocationManager locationServicesEnabled]) {
            NSLog(@"Calling startUpdatingLocation");
            [self.locationManager startUpdatingLocation];
        }
    }
}

- (void)rowTouchedBackgroundLocationServices {
    NSLog(@"Location Services requested");

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    SEL authorizationSelector = @selector(requestAlwaysAuthorization);
    if ([self.locationManager respondsToSelector:authorizationSelector]) {
        NSLog(@"Requesting background location authorization");
        [self.locationManager requestAlwaysAuthorization];
    } else {
        if ([CLLocationManager locationServicesEnabled]) {
            NSLog(@"Calling startUpdatingLocation");
            [self.locationManager startUpdatingLocation];
        }
    }
}

#pragma mark - Row Touched: Contacts

- (void)rowTouchedContacts {
    NSLog(@"Contacts requested");
    [[[CNContactStore alloc] init] requestAccessForEntityType:CNEntityTypeContacts
     completionHandler:^(BOOL granted, NSError * _Nullable error) {
     }];
}

#pragma mark - Row Touched: Calendars

- (void)rowTouchedCalendars {
    NSLog(@"Calendar requested");

    self.eventStore = [[EKEventStore alloc] init];

    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent
                                    completion:^(BOOL granted, NSError *error) {

                                    }];
}

- (void)rowTouchedReminders {
    NSLog(@"Reminders requested");

    self.eventStore = [[EKEventStore alloc] init];

    [self.eventStore requestAccessToEntityType:EKEntityTypeReminder
                                    completion:^(BOOL granted, NSError *error) {

                                    }];
}

#pragma mark - Row Touched: Photos

- (void)rowTouchedPhotos {
    NSLog(@"Photos requested");
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    [picker setDelegate:self];

    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Row Touched: Bluetooth

- (void)rowTouchedBluetooth {
    NSLog(@"Bluetooth Sharing is requested");

    [self presentViewController:[self.alertFactory alertForBluetoothFAKE]
                       animated:YES
                     completion:nil];

    /* Have not been able to generate a Bluetooth alert reliably, so we'll
     generate a fake one with the same title.
     if (!self.cbManager) {
     self.cbManager = [[CBCentralManager alloc]
     initWithDelegate:self
     queue:dispatch_get_main_queue()
     options:@{CBCentralManagerOptionShowPowerAlertKey: @(NO)}];
     }

     [self.cbManager scanForPeripheralsWithServices:nil options:nil];
     */
}

#pragma mark - Row Touched: Microphone

- (void)rowTouchedMicrophone {
    NSLog(@"Microphone requested");

    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            NSLog(@"Micro Permission Granted");
            NSError *error;

            if (![[AVAudioSession sharedInstance] setActive:YES error:&error]) {
                NSLog(@"error: %@", [error localizedDescription]);
            }

            if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord
                                                        error:&error]) {
                NSLog(@"error: %@", [error localizedDescription]);
            }

        } else {
            NSLog(@"Permission Denied");
        }
    }];
}

#pragma mark - Row Touched: Motion Activity

- (void)rowTouchedMotionActivity {
    NSLog(@"Motion Activity requested");
    self.cmManger = [[CMMotionActivityManager alloc]init];
    self.motionActivityQueue = [[NSOperationQueue alloc] init];

    [self.cmManger startActivityUpdatesToQueue:self.motionActivityQueue
                                   withHandler:^(CMMotionActivity *activity) {
                                   }];
}

#pragma mark - Row Touched: Camera

- (void)rowTouchedCamera {
    if ([AVCaptureDevice respondsToSelector:@selector(requestAccessForMediaType:completionHandler:)]) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            // Will get here on both iOS 7 & 8 even though camera permissions weren't required
            // until iOS 8. So for iOS 7 permission will always be granted.
            if (granted) {
                // Permission has been granted. Use dispatch_async for any UI updating
                // code because this block may be executed in a thread.
                dispatch_async(dispatch_get_main_queue(), ^{

                });
            } else {
                // Permission has been denied.
            }
        }];
    } else {
        // We are on iOS <= 6. Just do what we need to do.
    }
}

#pragma mark - Row Touched: Facebook

- (void)rowTouchedFacebook {
    // not yet
    // http://nsscreencast.com/episodes/57-facebook-integration

    [self presentViewController:[self.alertFactory alertForFacebookNYI]
                       animated:YES
                     completion:nil];

    /*
     NSLog(@"Facebook requested");
     if (!self.accountStore) {
     self.accountStore = [[ACAccountStore alloc] init];
     }
     ACAccountType *facebookAccount =
     [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];

     NSDictionary *options = @{
     ACFacebookAppIdKey:@"697227803740028",
     ACFacebookPermissionsKey:@[@"read_friendlists"],
     ACFacebookAudienceKey: ACFacebookAudienceFriends,
     };

     [self.accountStore
     requestAccessToAccountsWithType:facebookAccount
     options:options completion:^(BOOL granted,
     NSError *error) {
     if (granted) {
     NSLog(@"Facebook granted!");
     ACAccount *fbAccount = [[self.accountStore
     accountsWithAccountType:facebookAccount]
     lastObject];
     } else {
     NSLog(@"Not granted: %@", error);
     }

     }];
     */
}


#pragma mark - Row Touched: Twitter

- (void)rowTouchedTwitter {

    NSLog(@"Twitter Requested");

    if (!self.accountStore) {
        self.accountStore = [[ACAccountStore alloc] init];
    }
    ACAccountType *twitterAccount;
    twitterAccount = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

    [self.accountStore requestAccessToAccountsWithType:twitterAccount
                                               options:nil
                                            completion:^(BOOL granted, NSError *error) {

    }];
}

#pragma mark - Row Touched: Home Kit

- (void)rowTouchedHomeKit {
    [self presentViewController:[self.alertFactory alertForHomeKitNYI]
                       animated:YES
                     completion:nil];
}

#pragma mark - Row Touched: Health Kit

// http://jademind.com/blog/posts/healthkit-api-tutorial/
- (void)rowTouchedHealthKit {
    if ([[self view] isHealthKitAvailable]) {
        HKHealthStore *healthStore = [[HKHealthStore alloc] init];

        // Share body mass, height and body mass index
        NSSet *shareObjectTypes = [NSSet setWithObjects:
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex],
                                   nil];

        // Read date of birth, biological sex and step count
        NSSet *readObjectTypes  = [NSSet setWithObjects:
                                   [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth],
                                   [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                                   nil];

        // Request access
        [healthStore requestAuthorizationToShareTypes:shareObjectTypes
                                            readTypes:readObjectTypes
                                           completion:^(BOOL success, NSError *error) {
                                               if (success) {
                                                   NSLog(@"Successfully enabled HealthKit");
                                               } else {
                                                   NSLog(@"Did not enable HealthKit: %@",
                                                         [error localizedDescription]);
                                               }
                                           }];
    } else {
        [self presentViewController:[self.alertFactory alertForHomeKitNYI]
                           animated:YES
                         completion:nil];
    }
}

- (void)rowTouchedApns {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                          completionHandler:^(BOOL success, NSError *error) {
      if (success) {
        NSLog(@"");
      } else {
        NSLog(@"");
      }
    }];
}

#pragma mark - <UITableViewDataSource>

- (NSDictionary *)detailsForRowAtIndexPath:(NSIndexPath *) path {
    SEL selector = nil;
    NSString *title = nil;
    NSString *identifier = nil;

    CalTableRows row = (CalTableRows)path.row;

    switch (row) {
        case kRowLocationServices: {
            selector = @selector(rowTouchedLocationServices);
            title = @"Location Services";
            identifier = @"location";
            break;
        }

        case kRowBackgroundLocationServices: {
            selector = @selector(rowTouchedBackgroundLocationServices);
            title = @"Background Location Services";
            identifier = @"background location";
            break;
        }

        case kRowContacts: {
            selector = @selector(rowTouchedContacts);
            title = @"Contacts";
            identifier = @"contacts";
            break;
        }

        case kRowCalendars: {
            selector = @selector(rowTouchedCalendars);
            title = @"Calendar";
            identifier = @"calendar";
            break;
        }

        case kRowReminders: {
            selector = @selector(rowTouchedReminders);
            title = @"Reminders";
            identifier = @"reminders";
            break;
        }

        case kRowPhotos: {
            selector = @selector(rowTouchedPhotos);
            title = @"Photos";
            identifier = @"photos";
            break;
        }

        case kRowBlueTooth: {
            selector = @selector(rowTouchedBluetooth);
            title = @"Bluetooth Sharing";
            identifier = @"bluetooth";
            break;
        }

        case kRowMicrophone: {
            selector = @selector(rowTouchedMicrophone);
            title = @"Microphone";
            identifier = @"microphone";
            break;
        }

        case kRowMotionActivity: {
            selector = @selector(rowTouchedMotionActivity);
            title = @"Motion Activity";
            identifier = @"motion";
            break;
        }

        case kRowCamera: {
            selector = @selector(rowTouchedCamera);
            title = @"Camera";
            identifier = @"camera";
            break;
        }

        case kFacebook: {
            selector = @selector(rowTouchedFacebook);
            title = @"Facebook";
            identifier = @"facebook";
            break;
        }

        case kTwitter: {
            selector = @selector(rowTouchedTwitter);
            title = @"Twitter";
            identifier = @"twitter";
            break;
        }

        case kHomeKit: {
            selector = @selector(rowTouchedHomeKit);
            title = @"Home Kit";
            identifier = @"home kit";
            break;
        }

        case kHealthKit: {
            selector = @selector(rowTouchedHealthKit);
            title = @"Health Kit";
            identifier = @"health kit";
            break;
        }

        case kAPNS: {
            selector = @selector(rowTouchedApns);
            title = @"APNS";
            identifier = @"apns";
            break;
        }

        default: {
            NSString *reason;
            reason = [NSString stringWithFormat:@"Could not create row details for row %@",
                      @(row)];
            @throw [NSException exceptionWithName:@"Fell through switch"
                                           reason:reason
                                         userInfo:nil];

            break;
        }
    }

    return @{@"title" : title,
             @"selector" : NSStringFromSelector(selector),
             @"identifier" : identifier};
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) aSection {
    return kNumberOfRows;
}

- (UITableViewCell *) tableView:(UITableView *) tableView
          cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"
                                                            forIndexPath:indexPath];
    NSDictionary *dictionary = [self detailsForRowAtIndexPath:indexPath];

    NSString *title = dictionary[@"title"];

    UILabel *label = (UILabel *)[cell.contentView viewWithTag:3030];
    label.text = title;
    cell.accessibilityIdentifier = dictionary[@"identifier"];

    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
    return 44;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {

    NSDictionary *details = [self detailsForRowAtIndexPath:indexPath];
    SEL selector = NSSelectorFromString(details[@"selector"]);

    NSMethodSignature *signature;
    signature = [[self class] instanceMethodSignatureForSelector:selector];

    NSInvocation *invocation;
    invocation = [NSInvocation invocationWithMethodSignature:signature];

    invocation.target = self;
    invocation.selector = selector;

    [invocation invoke];

    double delayInSeconds = 0.4;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
}

#pragma mark - <CBCentralManagerDelegate>

- (void) centralManagerDidUpdateState:(CBCentralManager *)central{
    NSLog(@"Central Bluetooth manager did update state");
    if (central.state != CBCentralManagerStatePoweredOn) { return; }

    if (central.state == CBCentralManagerStatePoweredOn) {
        [self.cbManager scanForPeripheralsWithServices:nil options:nil];
    }
}

#pragma mark - <CLLocationManagerDelegate>

// This method is called whenever the application’s ability to use location
// services changes. Changes can occur because the user allowed or denied the
// use of location services for your application or for the system as a whole.
//
// If the authorization status is already known when you call the
// requestWhenInUseAuthorization or requestAlwaysAuthorization method, the
// location manager does not report the current authorization status to this
// method. The location manager only reports changes to the authorization
// status. For example, it calls this method when the status changes from
// kCLAuthorizationStatusNotDetermined to kCLAuthorizationStatusAuthorizedWhenInUse.
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"did change authorization status: %@", @(status));
    CLAuthorizationStatus notDetermined = kCLAuthorizationStatusNotDetermined;
    CLAuthorizationStatus denied = kCLAuthorizationStatusDenied;
    if (status != notDetermined && status != denied) {
        [manager startUpdatingLocation];
    } else {
        NSLog(@"Cannot update location because:");
        if (status == notDetermined) {
            NSLog(@"CoreLocation authorization is not determined");
        } else {
            NSLog(@"CoreLocation authorization is not denied");
        }
    }
}

#pragma mark - Orientation / Rotation

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL) shouldAutorotate {
    return YES;
}

#pragma mark - View Lifecycle

- (void)setContentInsets:(UITableView *)tableView {
    CGFloat topHeight = 0;
    if (![[UIApplication sharedApplication] isStatusBarHidden]) {
        CGRect frame = [[UIApplication sharedApplication] statusBarFrame];
        topHeight = topHeight + frame.size.height;
    }
    tableView.contentInset = UIEdgeInsetsMake(topHeight, 0, 0, 0);
}

- (void) viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setContentInsets:self.tableView];
    self.view.accessibilityIdentifier = @"page";
    self.tableView.accessibilityLabel = @"Permissions list";
    self.tableView.accessibilityIdentifier = @"table";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

@end

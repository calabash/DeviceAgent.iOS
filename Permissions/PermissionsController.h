
@import CoreBluetooth;

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PermissionsController : UITableViewController
<CLLocationManagerDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
CBCentralManagerDelegate,
UITableViewDataSource,
UITableViewDelegate>


@end

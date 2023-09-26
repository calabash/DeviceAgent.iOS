#import "PickersViewController.h"

@interface PickersViewController ()
@end

@implementation PickersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pickerItems = [NSArray arrayWithObjects:@"First", @"Second", "Third", "Fourth", nil];

    self.picker = [[UIPickerView alloc] init];
    self.picker.dataSource = pickerItems;
    self.pickerField.inputView = self.picker;
}

@end

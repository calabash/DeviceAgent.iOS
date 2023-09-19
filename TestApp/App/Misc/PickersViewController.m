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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PickersViewController : UIViewController {
    NSArray *pickerItems;
}
@property UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UITextField *pickerField;
@end

NS_ASSUME_NONNULL_END

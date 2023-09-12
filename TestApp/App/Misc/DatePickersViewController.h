#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DatePickersViewController : UIViewController {
    NSArray *pickerItems;
}
@property (strong, nonatomic) IBOutlet UITextField *dateField;
@property (strong, nonatomic) IBOutlet UITextField *timeField;

@property UIDatePicker *datePicker;
@property UIDatePicker *timePicker;
@end

NS_ASSUME_NONNULL_END

#import "DatePickersViewController.h"

@interface DatePickersViewController()
@end

@implementation DatePickersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pickerItems = [NSArray arrayWithObjects:@"First", @"Second", @"Third", @"Fourth", nil];

    // Initializing date picker.
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    self.dateField.inputView = self.datePicker;

    // Initializing time picker.
    self.timePicker = [[UIDatePicker alloc] init];
    self.timePicker.datePickerMode = UIDatePickerModeTime;
    self.timePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    self.timeField.inputView = self.timePicker;

    self.dateField.inputAccessoryView = [self setupToolbarForDatePicker];
    self.timeField.inputAccessoryView = [self setupToolbarForTimePicker];
}

- (UIToolbar *)setupToolbarForDatePicker {
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.sizeToFit;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target:self action:@selector(doneActionForDatePicker:)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolbar setItems:[NSArray arrayWithObjects:flexSpace, doneButton, nil]];
    return toolbar;
}

- (void)doneActionForDatePicker:(UIResponder *)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy";
    self.dateField.text = [dateFormatter stringFromDate:self.datePicker.date];
    [self.dateField endEditing:YES];
}

- (UIToolbar *)setupToolbarForTimePicker {
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.sizeToFit;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target:self action:@selector(doneActionForTimePicker:)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolbar setItems:[NSArray arrayWithObjects:doneButton, flexSpace, nil]];
    return toolbar;
}

- (void)doneActionForTimePicker:(UIResponder *)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    self.timeField.text = [dateFormatter stringFromDate:self.timePicker.date];
    [self.timeField endEditing:YES];
}

@end

//
//  PickerViewController.m
//  TestApp
//
//  Created by Ilya Bausov on 8/7/23.
//  Copyright © 2023 Calabash. All rights reserved.
//

#import "PickerViewController.h"

@interface PickerViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation PickerViewController

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
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [pickerItems count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [pickerItems objectAtIndex:row];
}
@end

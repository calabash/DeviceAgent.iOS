//
//  PickerViewController.m
//  TestApp
//
//  Created by Ilya Bausov on 8/7/23.
//  Copyright © 2023 Calabash. All rights reserved.
//

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
}

@end

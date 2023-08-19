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

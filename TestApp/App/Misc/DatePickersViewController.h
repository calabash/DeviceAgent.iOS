//
//  PickerViewController.h
//  TestApp
//
//  Created by Ilya Bausov on 8/7/23.
//  Copyright © 2023 Calabash. All rights reserved.
//

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

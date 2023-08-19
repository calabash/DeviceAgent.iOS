//
//  PickerViewController.h
//  TestApp
//
//  Created by Ilya Bausov on 8/7/23.
//  Copyright © 2023 Calabash. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PickerViewController: UIViewController<UIPickerViewDelegate, UIPickerViewDataSource> {
    NSArray *pickerItems;
}



@end

NS_ASSUME_NONNULL_END

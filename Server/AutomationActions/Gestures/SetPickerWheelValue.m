// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import "Application.h"
#import "CBXConstants.h"
#import "CBX-XCTest-Umbrella.h"
#import "CoordinateQueryConfiguration.h"
#import "GestureConfiguration.h"
#import "InvalidArgumentException.h"
#import "SetPickerWheelValue.h"
#import "Testmanagerd.h"
#import "ThreadUtils.h"
#import "Query.h"
#import "QueryConfiguration.h"
#import <UIKit/UIKit.h>
#import "XCTest+CBXAdditions.h"

@implementation SetPickerWheelValue

+ (NSString *)name { return @"set_picker_wheel_value"; }

+ (NSArray <NSString *> *)requiredKeys { return @[ CBX_PICKER_INDEX_KEY, CBX_PICKER_WHEEL_INDEX_KEY, CBX_PICKER_WHEEL_VALUE_KEY ]; }

+ (NSArray <NSString *> *)optionalKeys {
    return @[];
}

- (void)validate {
    if ([self.query.queryConfiguration isCoordinateQuery]) {
        return;
    }
}

+ (Gesture *)executeWithGestureConfiguration:(GestureConfiguration *)gestureConfig query:(Query *)query completion:(CompletionBlock)completion {
    if (![gestureConfig has:CBX_PICKER_INDEX_KEY]) {
        @throw [InvalidArgumentException withFormat:@"Missing required key 'picker_index'"];
    }

    if (![gestureConfig has:CBX_PICKER_WHEEL_INDEX_KEY]) {
        @throw [InvalidArgumentException withFormat:@"Missing required key 'picker_wheel_index'"];
    }

    if (![gestureConfig has:CBX_PICKER_WHEEL_VALUE_KEY]) {
        @throw [InvalidArgumentException withFormat:@"Missing required key 'picker_wheel_value'"];
    }

    int pickerIndex = [gestureConfig[CBX_PICKER_INDEX_KEY] intValue];
    int wheelIndex = [gestureConfig[CBX_PICKER_WHEEL_INDEX_KEY] intValue];
    NSString *value = gestureConfig[CBX_PICKER_WHEEL_VALUE_KEY];

    __block NSError *error = nil;
    [ThreadUtils runSync:^(BOOL *setToTrueWhenDone) {
        [Application setPickerWheelValue:pickerIndex
                              wheelIndex:wheelIndex
                                   value:value
                                   error:&error];
        *setToTrueWhenDone = YES;
    }];

    completion(nil);
    return nil;
}
@end

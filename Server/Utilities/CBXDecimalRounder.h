
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import <UIKit/UIKit.h>

/**
 A class for rounding floats to decimal places.
 */
@interface CBXDecimalRounder : NSObject

/**
 Rounds the float in the argument to 2 decimal places.

 @param cgFloat the float to round
 @return a CGFloat rounded to 2 decimal places.
 */
- (CGFloat)round:(CGFloat)cgFloat;

/**
 Rounds the cgFloat argument.

 @param cgFloat the float to round
 @param scale the number of decimal places after rounding.
 @return a CGFloat round to `scale` decimal places.
 */
- (CGFloat)round:(CGFloat)cgFloat withScale:(NSUInteger)scale;

/**
 Rounds the cgFloat to the nearest integer.

 @param cgFloat the float to round
 @return an NSInteger
 */
- (NSInteger)integerByRounding:(CGFloat)cgFloat;

@end

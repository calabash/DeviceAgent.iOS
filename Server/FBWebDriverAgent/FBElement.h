/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * 'Facebook-WebDriverAgent' file inside of the 'third-party-licenses' directory
 *  at the root of this project.
 */

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

NSString *wdAttributeNameForAttributeName(NSString *name);

@protocol FBElement <NSObject>

@property (readonly, assign) CGRect wdFrame;
@property (readonly, copy) NSDictionary *wdRect;
@property (readonly, copy) NSDictionary *wdSize;
@property (readonly, copy) NSDictionary *wdLocation;
@property (readonly, copy) NSString *wdName;
@property (readonly, copy) NSString *wdLabel;
@property (readonly, copy) NSString *wdType;
@property (readonly, copy) NSString *wdTitle; //new
@property (readonly, copy) NSString *wdPlaceholderValue; //new
@property (readonly, strong) id wdValue;
@property (readonly, getter = isWDEnabled) BOOL wdEnabled;

- (id)valueForWDAttributeName:(NSString *)name;
- (void)getHitPoint:(CGPoint *)point visibility:(BOOL *)visible;

@end

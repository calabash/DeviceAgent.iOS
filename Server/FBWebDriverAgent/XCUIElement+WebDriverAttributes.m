/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * 'Facebook-WebDriverAgent' file inside of the 'third-party-licenses' directory
 *  at the root of this project.
 */

#import "XCUIElement+WebDriverAttributes.h"
#import "XCUIElement+FBIsVisible.h"
#import "XCTest+CBXAdditions.h"
#import <objc/runtime.h>
#import "JSONUtils.h"

#define FBTransferEmptyStringToNil(value) ([value isEqual:@""] ? nil : value)
#define FBFirstNonEmptyValue(value1, value2) ([value1 isEqual:@""] ? value2 : value1)

@implementation XCUIElement (WebDriverAttributesForwarding)

- (id)forwardingTargetForSelector:(SEL)aSelector
{
  struct objc_method_description descr = protocol_getMethodDescription(@protocol(FBElement), aSelector, YES, YES);
  BOOL isWebDriverAttributesSelector = descr.name != nil;
  if(isWebDriverAttributesSelector) {
    if (!self.lastSnapshot) {
      [self resolve];
    }
    return self.lastSnapshot;
  }
  return nil;
}

@end


@implementation XCElementSnapshot (WebDriverAttributes)

- (id)valueForWDAttributeName:(NSString *)name
{
  return [self valueForKey:wdAttributeNameForAttributeName(name)];
}

- (id)wdValue
{
  id value = self.value;
  if (self.elementType == XCUIElementTypeStaticText) {
    value = FBFirstNonEmptyValue(self.value, self.label);
  }
  return FBTransferEmptyStringToNil(value);
}

- (NSString *)wdPlaceholderValue {
    return FBTransferEmptyStringToNil(self.placeholderValue);
}

- (NSString *)wdTitle {
    return FBTransferEmptyStringToNil(self.title);
}

- (NSString *)wdName
{
  return FBTransferEmptyStringToNil(FBFirstNonEmptyValue(self.identifier, self.label));
}

- (NSString *)wdLabel
{
  return FBTransferEmptyStringToNil(self.label);
}

- (NSString *)wdType
{
  return [JSONUtils stringForElementType:self.elementType];
}

- (CGRect)wdFrame
{
  return self.frame;
}

- (BOOL)isWDEnabled
{
  return self.isEnabled;
}

- (NSDictionary *)wdRect
{
  return
  @{
    @"origin":
      @{
        @"x": @(CGRectGetMinX(self.frame)),
        @"y": @(CGRectGetMinY(self.frame)),
        },
    @"size":
      @{
        @"width": @(CGRectGetWidth(self.frame)),
        @"height": @(CGRectGetHeight(self.frame)),
        },
    };
}

- (NSDictionary *)wdSize
{
    return self.wdRect[@"size"];
}

- (NSDictionary *)wdLocation
{
    return self.wdRect[@"origin"];
}

- (BOOL)isWDSelected
{
    return self.isSelected;
}

- (BOOL)wdHasFocus {
    return self.hasFocus;
}

- (BOOL)wdHasKeyboardFocus {
    return self.hasKeyboardFocus;
}

@end

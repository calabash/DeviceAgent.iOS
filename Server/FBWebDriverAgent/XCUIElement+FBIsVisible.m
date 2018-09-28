/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "CBX-XCTest-Umbrella.h"
#import "XCTest+CBXAdditions.h"
#import "XCUIElement+FBIsVisible.h"
#import "XCTestPrivateSymbols.h"
#import "XCElementSnapshot.h"
#import "XCAXClient_iOS.h"
#import "XCUIHitPointResult.h"
#import "CBXConstants.h"

@implementation CBXVisibilityResult

@end

@implementation XCUIElement (FBIsVisible)

- (CBXVisibilityResult *)visibilityResult {
  BOOL isVisible = self.isHittable;
  CBXVisibilityResult *result = [CBXVisibilityResult new];
  result.isVisible = isVisible;

  if (!isVisible) {
    result.point = CGPointMake(-1, -1);
  } else {
    // Starting in Xcode 9.3
    if ([self respondsToSelector:@selector(hitPointCoordinate)]) {
      XCUICoordinate *coordinate = self.hitPointCoordinate;
      result.point = coordinate.screenPoint;
    } else {
      return [self.lastSnapshot visibilityResult];
    }
  }
  
  return result;
}

@end

#pragma mark - XCElementSnapshot

@implementation XCElementSnapshot (FBIsVisible)

- (id)fb_attributeValue:(NSNumber *)attribute
{
  NSDictionary *attributesResult = [[XCAXClient_iOS sharedClient]
                                    attributesForElementSnapshot:self
                                    attributeList:@[attribute]];
  return (id __nonnull)attributesResult[attribute];
}

- (CBXVisibilityResult *)visibilityResult {
  CBXVisibilityResult *cbxResult = [CBXVisibilityResult new];
  // r26 = *(int8_t *)__XCShouldUseHostedViewConversion.shouldUseHostedViewConversion | r9;
  // This flag isn't important
  // int8_t flag;
  CGPoint intermediate;
  XCUIHitPointResult *result = [self hitPoint:NULL];

  cbxResult.isVisible = result.isHittable;

  if (result.isHittable) {
    intermediate = result.hitPoint;
  } else {
    intermediate = CGPointMake(-1, -1);
  }

  cbxResult.point = intermediate;

  DDLogDebug(@"Finding hit point for XCElementSnapshot: %@\n"
  "hitpoint: %@\n"
  "visible: %@\n",
  self,
  [NSString stringWithFormat:@"(%@, %@)", @(intermediate.x), @(intermediate.y)],
  result.isHittable ? @"YES" : @"NO");
  
  return cbxResult;
}

@end

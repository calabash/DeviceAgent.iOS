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

- (BOOL)fb_isVisible
{
  if (!self.lastSnapshot) {
    [self resolve];
  }
  return self.lastSnapshot.fb_isVisible;
}

- (CBXVisibilityResult *)visibilityResult {
  BOOL isVisible = self.isHittable;
  CBXVisibilityResult *result = [CBXVisibilityResult new];

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

- (BOOL)fb_isVisible
{
  if (CGRectIsEmpty(self.frame) || CGRectIsEmpty(self.visibleFrame)) {
    /*
     It turns out, that XCTest triggers
       Enqueue Failure: UI Testing Failure - Failure fetching attributes for element
       <XCAccessibilityElement: 0x60000025f9e0> Device element: Error Domain=XCTestManagerErrorDomain Code=13
       "Error copying attributes -25202" UserInfo={NSLocalizedDescription=Error copying attributes -25202} <unknown> 0 1
     error in the log if we try to get visibility attribute for an element snapshot, which does not intersect with visible application area
     or if it has zero width/height. Also, XCTest waits for 15 seconds after this line appears in the log, which makes /source command
     execution extremely slow for some applications.
     */
    return NO;
  }

  /*
   * Following the advice above, it seems prudent to check if the snapshot frame
   * intersects with the application frame.
   *
   * This does not seem to slow down the execution too much and it results in fewer
   * "Failure fetching attributes for element" failures.
   */
  XCUIApplication *application = [self application];
  [XCUIApplication cbxResolveApplication:application];

  CGRect appFrame = [[application cbxXCElementSnapshot] frame];

  if (!CGRectIntersectsRect(appFrame, self.frame)) {
    return NO;
  }

  return [(NSNumber *)[self fb_attributeValue:FB_XCAXAIsVisibleAttribute] boolValue];
}

- (id)fb_attributeValue:(NSNumber *)attribute
{
  NSDictionary *attributesResult = [[XCAXClient_iOS sharedClient]
                                    attributesForElementSnapshot:self
                                    attributeList:@[attribute]];
  return (id __nonnull)attributesResult[attribute];
}

- (CBXVisibilityResult *)visibilityResult {
  CBXVisibilityResult *cbxResult = [CBXVisibilityResult new];
  // Starting in Xcode 9.3
  if ([self respondsToSelector:@selector(hitPoint:)]) {
    // r26 = *(int8_t *)__XCShouldUseHostedViewConversion.shouldUseHostedViewConversion | r9;
    int8_t flag;
    CGPoint intermediate;
    XCUIHitPointResult *result = [self hitPoint:&flag];

    cbxResult.isVisible = result.isHittable;
    if (result.isHittable) {
      intermediate = result.hitPoint;
    } else {
      intermediate = CGPointMake(-1, -1);
    }

    cbxResult.point = intermediate;

    DDLogDebug(@"Finding hit point for XCElementSnapshot: %@\n"
    "hitpoint: %@\n"
    "visible: %@\n"
    "hosted conversion flag: %@",
    self,
    [NSString stringWithFormat:@"(%@, %@)", @(intermediate.x), @(intermediate.y)],
    result.isHittable ? @"YES" : @"NO", @(flag));
  } else {
    cbxResult.point = [XCElementSnapshot cbxHitPointFromLastSnapshot:self];
    cbxResult.isVisible = self.fb_isVisible;

    if (!cbxResult.isVisible) {
      cbxResult.point = CGPointMake(-1, -1);
    } else {
      cbxResult.point = [XCElementSnapshot cbxHitPointFromLastSnapshot:self];
    }
  }
  
  return cbxResult;
}

+ (CGPoint)cbxHitPointFromLastSnapshot:(XCElementSnapshot *)snapshot {

  SEL selector = @selector(hitPoint);
  Class klass = [snapshot class];

  NSMethodSignature *signature;
  signature = [klass instanceMethodSignatureForSelector:selector];
  NSInvocation *invocation;

  invocation = [NSInvocation invocationWithMethodSignature:signature];
  invocation.target = snapshot;
  invocation.selector = selector;

  [invocation invoke];

  CGPoint point = CGPointMake(-1, -1);
  [invocation getReturnValue:(void **) &point];

  return point;
}

@end

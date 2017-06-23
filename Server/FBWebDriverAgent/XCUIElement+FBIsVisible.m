/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "XCUIElement+FBIsVisible.h"
#import "XCAXClient_iOS.h"
#import "XCTestPrivateSymbols.h"
#import "XCElementSnapshot-Hitpoint.h"
#import "XCUIApplication.h"
#import "XCApplicationQuery.h"

@implementation XCUIElement (FBIsVisible)

- (BOOL)fb_isVisible
{
  if (!self.lastSnapshot) {
    [self resolve];
  }
  return self.lastSnapshot.fb_isVisible;
}

- (void)getHitPoint:(CGPoint *)point visibility:(BOOL *)visible {
  BOOL isVisible = self.fb_isVisible;
  *visible = isVisible;

  if (!isVisible) {
    *point = CGPointMake(-1, -1);
  } else {
    *point = self.lastSnapshot.hitPoint;
  }
}

@end

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
  if (!application.lastSnapshot) {
      [[application applicationQuery] elementBoundByIndex:0];
      [application resolve];
  }
  CGRect appFrame = application.lastSnapshot.frame;

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

- (void)getHitPoint:(CGPoint *)point visibility:(BOOL *)visible {
  BOOL isVisible = self.fb_isVisible;
  *visible = isVisible;

  if (!isVisible) {
    *point = CGPointMake(-1, -1);
  } else {
    *point = self.hitPoint;
  }
}

@end

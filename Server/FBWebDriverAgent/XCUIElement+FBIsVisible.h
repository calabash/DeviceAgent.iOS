/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import "XCElementSnapshot.h"

@class XCUIElement;

NS_ASSUME_NONNULL_BEGIN

@interface CBXVisibilityResult : NSObject

@property (nonatomic, assign) BOOL isVisible;
@property (nonatomic, assign) CGPoint point;

@end

@interface XCUIElement (FBIsVisible)

/*! Whether or not the element is visible */
@property (atomic, readonly) BOOL fb_isVisible;

/*! Get hitpoint and visibility information.  Asking for the hitpoint of an element that
 * is not visible can lead to:
 *
 * UI Testing Failure - Failure fetching attributes for element <XCAccessibilityElement:>
 *   Device element: Error Domain=XCTestManagerErrorDomain Code=13
 *   "Error copying attributes -25202"
 *     UserInfo={NSLocalizedDescription=Error copying attributes -25202} <unknown> 0 1
 *
 * and asking if an element is visible is expensive.
 */
- (CBXVisibilityResult *)visibilityResult;

@end

@interface XCElementSnapshot (FBIsVisible)

/*! Whether or not the element is visible */
@property (atomic, readonly) BOOL fb_isVisible;

/*! Get hitpoint and visibility information.  Asking for the hitpoint of an element that
 * is not visible can lead to:
 *
 * UI Testing Failure - Failure fetching attributes for element <XCAccessibilityElement:>
 *   Device element: Error Domain=XCTestManagerErrorDomain Code=13
 *   "Error copying attributes -25202"
 *     UserInfo={NSLocalizedDescription=Error copying attributes -25202} <unknown> 0 1
 *
 * and asking if an element is visible is expensive.
 */
- (CBXVisibilityResult *)visibilityResult;

@end

NS_ASSUME_NONNULL_END

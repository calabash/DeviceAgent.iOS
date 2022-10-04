
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import "XCTest+CBXAdditions.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBXVisibilityResult : NSObject

@property (nonatomic, assign) BOOL isVisible;
@property (nonatomic, assign) CGPoint point;

@end

@interface XCUIElement (VisibilityResult)

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

//@interface XCElementSnapshot (VisibilityResult)
//
///*! Get hitpoint and visibility information.  Asking for the hitpoint of an element that
// * is not visible can lead to:
// *
// * UI Testing Failure - Failure fetching attributes for element <XCAccessibilityElement:>
// *   Device element: Error Domain=XCTestManagerErrorDomain Code=13
// *   "Error copying attributes -25202"
// *     UserInfo={NSLocalizedDescription=Error copying attributes -25202} <unknown> 0 1
// *
// * and asking if an element is visible is expensive.
// */
//- (CBXVisibilityResult *)visibilityResult;
//
//@end

NS_ASSUME_NONNULL_END

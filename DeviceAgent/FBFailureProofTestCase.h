/**
 * Original copyright notice.
 *
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
 # PATENTS: https://github.com/facebook/WebDriverAgent/blob/master/PATENTS
 * LICENSE: https://github.com/facebook/WebDriverAgent/blob/master/LICENSE
 *
 * The license for this source code can be found in the root directory of this
 * source tree under Licenses/.
 */

// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.
 
#import <Foundation/Foundation.h>
#import <XCTestCore/XCTestCase.h>

@class _XCTestCaseImplementation;

NS_ASSUME_NONNULL_BEGIN

@interface XCTestCase (CBXAdditions)

- (_XCTestCaseImplementation *)internalImplementation;
- (void)setInternalImplementation:(_XCTestCaseImplementation *)implementation;
@property(nonatomic) BOOL shouldHaltWhenReceivesControl;
@property(nonatomic) BOOL shouldSetShouldHaltWhenReceivesControl;
@end

/**
 Test Case that will never fail or stop from running in case of failure
 */
@interface FBFailureProofTestCase : XCTestCase
@end

NS_ASSUME_NONNULL_END

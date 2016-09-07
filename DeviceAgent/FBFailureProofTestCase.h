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
 
#import <Foundation/Foundation.h>
#import "XCTestCase.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Test Case that will never fail or stop from running in case of failure
 */
@interface FBFailureProofTestCase : XCTestCase
@end

/**
 Class that can be used to proxy existing _XCTestCaseImplementation and
 prevent currently running test from being terminated on any XCTest failure
 */
@interface FBXCTestCaseImplementationFailureHoldingProxy : NSProxy

/**
 Constructor for given existing _XCTestCaseImplementation instance
 */
+ (instancetype)proxyWithXCTestCaseImplementation:(_XCTestCaseImplementation *)internalImplementation;

@end

NS_ASSUME_NONNULL_END

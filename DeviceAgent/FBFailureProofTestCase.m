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

#import "FBFailureProofTestCase.h"
#import "_XCTestCaseImplementation.h"

@interface FBFailureProofTestCase ()
@property (nonatomic, assign) BOOL didRegisterAXTestFailure;
@end

@implementation FBFailureProofTestCase

- (void)setUp {
  [super setUp];
  self.continueAfterFailure = YES;
  self.internalImplementation = (_XCTestCaseImplementation *)[FBXCTestCaseImplementationFailureHoldingProxy
  proxyWithXCTestCaseImplementation:self.internalImplementation];
}

/**
 Private XCTestCase method used to block and tunnel failure messages
 */
- (void)_enqueueFailureWithDescription:(NSString *)description
                                inFile:(NSString *)filePath
                                atLine:(NSUInteger)lineNumber
                              expected:(BOOL)expected
{
    NSLog(@"Enqueue Failure: %@ %@ %lu %d", description, filePath, (unsigned long)lineNumber, expected);
    const BOOL isPossibleDeadlock = ([description rangeOfString:@"Failed to get refreshed snapshot"].location != NSNotFound);
    if (!isPossibleDeadlock) {
        self.didRegisterAXTestFailure = YES;
    } else if (self.didRegisterAXTestFailure) {
        self.didRegisterAXTestFailure = NO; // Reseting to NO to enable future deadlock detection
        [[NSException exceptionWithName:@"DeviceAgentDeadlockDetectedException"
                                 reason:@"Can't communicate with deadlocked application"
                               userInfo:nil]
         raise];
    }
}

@end

@interface FBXCTestCaseImplementationFailureHoldingProxy ()
@property (nonatomic, strong) _XCTestCaseImplementation *internalImplementation;
@end

@implementation FBXCTestCaseImplementationFailureHoldingProxy

+ (instancetype)proxyWithXCTestCaseImplementation:(_XCTestCaseImplementation *)internalImplementation
{
    FBXCTestCaseImplementationFailureHoldingProxy *proxy = [super alloc];
    proxy.internalImplementation = internalImplementation;
    return proxy;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.internalImplementation;
}

// This will prevent test from quiting on app crash or any other test failure
- (BOOL)shouldHaltWhenReceivesControl
{
    return NO;
}

@end

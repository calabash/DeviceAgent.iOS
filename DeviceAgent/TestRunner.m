
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import "CBXCUITestServer.h"
#import "FBFailureProofTestCase.h"

@interface TestRunner : FBFailureProofTestCase

@end

@implementation TestRunner

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = YES;
    
    /*
     *  Route exceptions should be caught inside of the server.
     *  Any exception that makes it this far should therefore kill the test. 
     */
    NSSetUncaughtExceptionHandler(&handleException);
}

- (void)tearDown {
    [super tearDown];
}

- (void)testRunner {
    NSLog(@"TEST RUNNER IS STARTING");
    [CBXCUITestServer start];
    NSLog(@"TEST RUNNER HAS FINISHED.");
}

void handleException(NSException *e) {
    NSLog(@"Caught %@", e);
    NSLog(@"Stopping server due to an exception");
    [CBXCUITestServer stop];
}

@end

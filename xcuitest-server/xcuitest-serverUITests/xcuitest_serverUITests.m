//
//  xcuitest_serverUITests.m
//  xcuitest-serverUITests
//

#import "CBShutdownServerException.h"
#import "CBXCUITestServer.h"
#import <XCTest/XCTest.h>

@interface xcuitest_serverUITests : XCTestCase

@end

@implementation xcuitest_serverUITests

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = YES;
    
    /*
     *  Route exceptions should be caught inside of the server.
     *  Any exception that makes it this far should therefore kill the test. 
     */
    NSSetUncaughtExceptionHandler(&HandleException);
}

- (void)tearDown {
    [super tearDown];
}

- (void)testRunner {
    [CBXCUITestServer start];
    NSLog(@"TEST RUNNER HAS FINISHED.");
}

void HandleException(NSException *e) {
    int code = [e isKindOfClass:[CBShutdownServerException class]] ? EXIT_SUCCESS : EXIT_FAILURE;
    [CBXCUITestServer stop];
    exit(code);
}



@end

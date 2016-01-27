//
//  xcuitest_serverUITests.m
//  xcuitest-serverUITests
//
//  Created by Chris Fuentes on 1/26/16.
//  Copyright © 2016 calabash. All rights reserved.
//

#import "CBXCUITestServer.h"
#import <XCTest/XCTest.h>

@interface xcuitest_serverUITests : XCTestCase

@end

@implementation xcuitest_serverUITests

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = YES;
}

- (void)tearDown {
    [super tearDown];
}

- (void)testRunner {
    [CBXCUITestServer start];
}

@end

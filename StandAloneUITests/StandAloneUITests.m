
#import <XCTest/XCTest.h>

@interface StandAloneUITests : XCTestCase

@end

@implementation StandAloneUITests

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = NO;
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
    [[[XCUIApplication alloc] init] launch];
}

@end

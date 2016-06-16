#import <XCTest/XCTest.h>
#import "Gesture.h"
#import "Application.h"

@interface GestureTest : XCTestCase

@end

@implementation GestureTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInterfaceOrientation {
    XCUIApplication *app = [Application currentApplication];
    UIInterfaceOrientation expected = [app interfaceOrientation];

    UIInterfaceOrientation actual = [Gesture interfaceOrientation];
    expect(actual).to.equal(expected);
}

@end

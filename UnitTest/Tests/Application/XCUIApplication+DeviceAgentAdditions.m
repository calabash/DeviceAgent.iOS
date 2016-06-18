#import <XCTest/XCTest.h>
#import "XCUIApplication+DeviceAgentAdditions.h"
#import "Application.h"

@interface XCUIApplication_DeviceAgentAdditionsTest : XCTestCase

@end

@implementation XCUIApplication_DeviceAgentAdditionsTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testLongLongOrientation {
    XCUIApplication *xuiApp = [Application currentApplication];
    UIInterfaceOrientation orientation = [xuiApp interfaceOrientation];
    long long longOrientation = [xuiApp longLongInterfaceOrientation];

    expect(longOrientation).to.equal((long long)orientation);
}

@end

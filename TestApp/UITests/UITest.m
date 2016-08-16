#import <XCTest/XCTest.h>

@interface UITest : XCTestCase

@end

@implementation UITest

- (void)setUp {
    [super setUp];
    
    self.continueAfterFailure = NO;
    [[[XCUIApplication alloc] init] launch];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testRotate {
    [XCUIDevice sharedDevice].orientation = UIInterfaceOrientationLandscapeLeft;
//    UIDeviceOrientation deviceOrientation = [XCUIDevice sharedDevice].orientation;
//    NSLog(@"device orientation = %@", @(deviceOrientation));
//
//    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
//    NSLog(@"interface orientation = %@", @(interfaceOrientation));
//
//    XCTAssertEqual([@(deviceOrientation) integerValue],
//                   [@(interfaceOrientation) integerValue]);
}

@end

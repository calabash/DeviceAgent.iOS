#import <XCTest/XCTest.h>

@interface UITest : XCTestCase

@property(strong) XCUIApplication *aut;

@end

@implementation UITest

- (void)setUp {
    [super setUp];
    
    self.continueAfterFailure = NO;
    self.aut = [[XCUIApplication alloc] init];
    [self.aut launch];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testRotate {
//    [XCUIDevice sharedDevice].orientation = UIInterfaceOrientationLandscapeLeft;
//    UIDeviceOrientation deviceOrientation = [XCUIDevice sharedDevice].orientation;
//    NSLog(@"device orientation = %@", @(deviceOrientation));
//
//    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
//    NSLog(@"interface orientation = %@", @(interfaceOrientation));
//
//    XCTAssertEqual([@(deviceOrientation) integerValue],
//                   [@(interfaceOrientation) integerValue]);
}

- (void)testTextEntry {
    [XCUIDevice sharedDevice].orientation = UIDeviceOrientationPortrait;

    [self.aut.tabBars.buttons[@"Misc"] tap];

    [self.aut.textFields[@"text field"] tap];
    [self.aut typeText:@"Good"];
    [self.aut.buttons[@"Done"] tap];


    XCUIElement *element = self.aut.staticTexts[@"question"];
    NSString *answer = [element label];

    XCTAssertEqualObjects(answer, @"Ça va? - Good");
}

@end

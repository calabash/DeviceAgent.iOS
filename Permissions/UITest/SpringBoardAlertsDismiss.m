#import "XCTest+CBXAdditions.h"
#import "CBXServerUnitTestUmbrellaHeader.h"
#import "SpringBoardAlerts.h"
#import "SpringBoardAlert.h"
#import "SpringBoard.h"
#import <XCTest/XCTest.h>

@interface SpringBoardAlertsDismiss : XCTestCase

@property(strong) XCUIApplication *app;

@end

@implementation SpringBoardAlertsDismiss

- (void)setUp {
    [super setUp];
    self.app = [[XCUIApplication alloc] init];
    [self.app launch];
}

- (void)tearDown {
    [super tearDown];
}

-(void)waitUntilElementExists:(XCUIElement *)element withTimeout:(NSTimeInterval)timeout {
    NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
    while (!element.exists) {
        if ([NSDate timeIntervalSinceReferenceDate] - startTime > timeout) {
            XCTFail(@"Timed out waiting for element to exist");
            return;
        }
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.1, false);
    }
}

- (void)testDismissReminders {
    XCUIElement *element = self.app.tables[@"table"].cells[@"reminders"];
    [self waitUntilElementExists:element withTimeout:5];
    [element tap];
    [[SpringBoard application] handleAlertsOrThrow];
}

@end

#import "XCTest+CBXAdditions.h"
#import "SpringBoardAlerts.h"
#import "SpringBoardAlert.h"
#import "SpringBoard.h"

/// TestCase for checking automatic dismissing of SpringBoard alerts.
@interface SpringBoardAlertsDismissAuto : XCTestCase

@property(strong) XCUIApplication *app;

@end

@implementation SpringBoardAlertsDismissAuto

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

-(void)CheckDismissAlertForCell:(NSString *)tableRowName {
    XCUIElement *tableRow = self.app.tables[@"table"].cells[tableRowName];
    [self waitUntilElementExists:tableRow withTimeout:5];
    [tableRow tap];
    XCTAssertNoThrow([[SpringBoard application] handleAlertsOrThrow],
                     @"Handling of alert for '%@' row raised an exception",
                     tableRowName);
}

/// Check that "Location Services" access alert is being handled automatically.
- (void)testDismissLocationServices {
    [self CheckDismissAlertForCell:@"location"];
}

/// Check that "Background Location Services" access alert is being handled automatically.
- (void)testDismissBackgroundLocationServices {
    [self CheckDismissAlertForCell:@"background location"];
}

/// Check that "Contacts" access alert is being handled automatically.
- (void)testDismissContacts {
    [self CheckDismissAlertForCell:@"contacts"];
}

/// Check that "Calendar" access alert is being handled automatically.
- (void)testDismissCalendar {
    [self CheckDismissAlertForCell:@"calendar"];
}

/// Check that "Reminders" access alert is being handled automatically.
- (void)testDismissReminders {
    [self CheckDismissAlertForCell:@"reminders"];
}

/// Check that "Photos" access alert is being handled automatically.
- (void)testDismissPhotos {
    [self CheckDismissAlertForCell:@"photos"];
}

/// Check that "Bluetooth Sharing" access alert is being handled automatically.
- (void)testDismissBluetoothSharing {
    [self CheckDismissAlertForCell:@"bluetooth"];
}

/// Check that "Microphone" access alert is being handled automatically.
- (void)testDismissMicrophone {
    [self CheckDismissAlertForCell:@"microphone"];
}

/// Check that "Motion Activity" access alert is being handled automatically.
- (void)testDismissMotionActivity {
    [self CheckDismissAlertForCell:@"motion"];
}

/// Check that "Camera" access alert is being handled automatically.
- (void)testDismissCamera {
    [self CheckDismissAlertForCell:@"camera"];
}

/// Check that "Facebook" access alert is being handled automatically.
- (void)testDismissFacebook {
    [self CheckDismissAlertForCell:@"facebook"];
}

/// Check that "Twitter" access alert is being handled automatically.
- (void)testDismissTwitter {
    [self CheckDismissAlertForCell:@"twitter"];
}

/// Check that "Home Kit" access alert is being handled automatically.
- (void)testDismissHomeKit {
    [self CheckDismissAlertForCell:@"home kit"];
}

/// Check that "Health Kit" access alert is being handled automatically.
- (void)testDismissHealthKit {
    [self CheckDismissAlertForCell:@"health kit"];
}

/// Check that "APNS" access alert is being handled automatically.
- (void)testDismissAPNS {
    [self CheckDismissAlertForCell:@"apns"];
}

@end

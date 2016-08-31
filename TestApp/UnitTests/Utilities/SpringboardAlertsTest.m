
#import "SpringboardAlerts.h"
#import "SpringboardAlert.h"

#pragma mark - PrivacyAlerts

@interface SpringboardAlerts(TEST)

- (NSMutableArray<SpringboardAlert *> *)alerts;

@end

@interface SpringboardAlertsTest : XCTestCase

@end

@implementation SpringboardAlertsTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testAlerts {
    NSArray<SpringboardAlert *> *actual;
    actual = [[SpringboardAlerts shared] alerts];
    expect(actual.count).to.equal(83);
}

- (void)testAlertForTitle {
    NSString *alertTitle, *expectedButton;
    BOOL expectedShouldAccept;
    SpringboardAlert *actual;

    alertTitle = @"Some alert generated Springboard that we cannot handle";
    actual = [[SpringboardAlerts shared] springboardAlertForAlertTitle:alertTitle];

    expect(actual).to.equal(nil);

    alertTitle = @"souhaite accéder à vos rappels";
    expectedButton = @"OK";
    expectedShouldAccept = YES;
    actual = [[SpringboardAlerts shared] springboardAlertForAlertTitle:alertTitle];

    expect(actual.defaultDismissButtonMark).to.equal(expectedButton);
    expect(actual.shouldAccept).to.equal(expectedShouldAccept);

    alertTitle = @"запрашивает разрешение на использование Ващей текущей пгеопозиции";
    expectedButton = @"OK";
    expectedShouldAccept = YES;
    actual = [[SpringboardAlerts shared] springboardAlertForAlertTitle:alertTitle];

    expect(actual.defaultDismissButtonMark).to.equal(expectedButton);
    expect(actual.shouldAccept).to.equal(expectedShouldAccept);

    alertTitle = @"No SIM Card Installed";
    expectedButton = @"OK";
    expectedShouldAccept = YES;
    actual = [[SpringboardAlerts shared] springboardAlertForAlertTitle:alertTitle];

    expect(actual.defaultDismissButtonMark).to.equal(expectedButton);
    expect(actual.shouldAccept).to.equal(expectedShouldAccept);

    alertTitle = @"Carrier Settings Update";
    expectedButton = @"Not Now";
    expectedShouldAccept = NO;
    actual = [[SpringboardAlerts shared] springboardAlertForAlertTitle:alertTitle];

    expect(actual.defaultDismissButtonMark).to.equal(expectedButton);
    expect(actual.shouldAccept).to.equal(expectedShouldAccept);
}

@end

#pragma mark - PrivacyAlert


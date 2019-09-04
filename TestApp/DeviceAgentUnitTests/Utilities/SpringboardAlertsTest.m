
#import "CBXServerUnitTestUmbrellaHeader.h"
#import "SpringBoardAlerts.h"
#import "SpringBoardAlert.h"

#pragma mark - PrivacyAlerts

@interface SpringBoardAlerts(TEST)

- (NSMutableArray<SpringBoardAlert *> *)alerts;

@end

@interface SpringBoardAlertsTest : XCTestCase

@end

@implementation SpringBoardAlertsTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testAlerts {
    NSArray<SpringBoardAlert *> *actual;
    actual = [[SpringBoardAlerts shared] alerts];
    expect(actual.count > 0).to.beTruthy();
}

- (void)testAlertForTitle {
    NSString *alertTitle, *expectedButton;
    BOOL expectedShouldAccept;
    SpringBoardAlert *actual;

    alertTitle = @"Some alert generated SpringBoard that we cannot handle";
    actual = [[SpringBoardAlerts shared] alertMatchingTitle:alertTitle];

    expect(actual).to.equal(nil);

    alertTitle = @"souhaite accéder à vos rappels";
    expectedButton = @"OK";
    expectedShouldAccept = YES;
    actual = [[SpringBoardAlerts shared] alertMatchingTitle:alertTitle];

    expect(actual.defaultDismissButtonMarks).to.contain(expectedButton);
    expect(actual.shouldAccept).to.equal(expectedShouldAccept);

    alertTitle = @"запрашивает разрешение на использование Вашей текущей геопозиции";
    expectedButton = @"OK";
    expectedShouldAccept = YES;
    actual = [[SpringBoardAlerts shared] alertMatchingTitle:alertTitle];

    expect(actual.defaultDismissButtonMarks).to.contain(expectedButton);
    expect(actual.shouldAccept).to.equal(expectedShouldAccept);

    alertTitle = @"No SIM Card Installed";
    expectedButton = @"OK";
    expectedShouldAccept = YES;
    actual = [[SpringBoardAlerts shared] alertMatchingTitle:alertTitle];

    expect(actual.defaultDismissButtonMarks).to.contain(expectedButton);
    expect(actual.shouldAccept).to.equal(expectedShouldAccept);

    alertTitle = @"Carrier Settings Update";
    expectedButton = @"Not Now";
    expectedShouldAccept = NO;
    actual = [[SpringBoardAlerts shared] alertMatchingTitle:alertTitle];

    expect(actual.defaultDismissButtonMarks).to.contain(expectedButton);
    expect(actual.shouldAccept).to.equal(expectedShouldAccept);

    alertTitle = @"acesso à sua localização";
    expectedButton = @"Permitir";
    expectedShouldAccept = YES;
    actual = [[SpringBoardAlerts shared] alertMatchingTitle:alertTitle];

    expect(actual.defaultDismissButtonMarks).to.contain(expectedButton);
    expect(actual.shouldAccept).to.equal(expectedShouldAccept);
}

@end

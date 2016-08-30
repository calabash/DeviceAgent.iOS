
#import "SpringboardAlerts.h"
#import "SpringboardAlert.h"

@interface SpringboardAlert (TEST)

- (instancetype)initWithAlertTitleFragment:(NSString *)matchText
                        dismissButtonTitle:(NSString *)acceptButtonTitle
                              shouldAccept:(BOOL)shouldAccept;
- (NSString *)alertTitleFragment;
- (BOOL)matchesAlertTitle:(NSString *)alertTitle;

@end

@interface SpringboardAlertTest : XCTestCase

@end

@implementation SpringboardAlertTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInit {
    SpringboardAlert *alert;
    alert = [[SpringboardAlert alloc] initWithAlertTitleFragment:@"match"
                                              dismissButtonTitle:@"OK"
                                                    shouldAccept:YES];

    expect(alert.alertTitleFragment).to.equal(@"match");
    expect(alert.defaultDismissButtonMark).to.equal(@"OK");
    expect(alert.shouldAccept).to.equal(YES);

    alert = [[SpringboardAlert alloc] initWithAlertTitleFragment:@"match"
                                              dismissButtonTitle:@"Dismiss"
                                                    shouldAccept:NO];
    expect(alert.alertTitleFragment).to.equal(@"match");
    expect(alert.defaultDismissButtonMark).to.equal(@"Dismiss");
    expect(alert.shouldAccept).to.equal(NO);
}

- (void)testMatchesAlertTitle {
    SpringboardAlert *alert;
    alert = [[SpringboardAlert alloc] initWithAlertTitleFragment:@"match"
                                              dismissButtonTitle:@"OK"
                                                    shouldAccept:YES];

    BOOL actual = [alert matchesAlertTitle:@"Found a match"];
    expect(actual).to.equal(YES);

    actual = [alert matchesAlertTitle:@"Not found"];
    expect(actual).to.equal(NO);
}

@end

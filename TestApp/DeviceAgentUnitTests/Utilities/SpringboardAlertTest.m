
#import "CBXServerUnitTestUmbrellaHeader.h"
#import <Foundation/Foundation.h>
#import "SpringBoardAlerts.h"
#import "SpringBoardAlert.h"

@interface SpringBoardAlert (TEST)

- (instancetype)initWithAlertTitleFragment:(NSString *)matchText
                        dismissButtonTitles:(NSArray *)acceptButtonTitle
                              shouldAccept:(BOOL)shouldAccept;
- (NSString *)alertTitleFragment;
- (BOOL)matchesAlertTitle:(NSString *)alertTitle;

@end

@interface SpringBoardAlertTest : XCTestCase

@end

@implementation SpringBoardAlertTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInit {
    SpringBoardAlert *alert;
    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"match"
                                              dismissButtonTitles:[NSArray arrayWithObjects: @"OK", nil]
                                                    shouldAccept:YES];

    expect(alert.alertTitleFragment).to.equal(@"match");
    expect(alert.defaultDismissButtonMarks).to.contain(@"OK");
    expect(alert.shouldAccept).to.equal(YES);

    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"match"
                                              dismissButtonTitles:[NSArray arrayWithObjects: @"Dismiss", nil]
                                                    shouldAccept:NO];
    expect(alert.alertTitleFragment).to.equal(@"match");
    expect(alert.defaultDismissButtonMarks).to.contain(@"Dismiss");
    expect(alert.shouldAccept).to.equal(NO);
}

- (void)testMatchesAlertTitle {
    SpringBoardAlert *alert;
    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"match"
                                              dismissButtonTitles:[NSArray arrayWithObjects: @"OK", nil]
                                                    shouldAccept:YES];

    BOOL actual = [alert matchesAlertTitle:@"Found a match"];
    expect(actual).to.equal(YES);

    actual = [alert matchesAlertTitle:@"Not found"];
    expect(actual).to.equal(NO);

    // matching is done with lowercase strings
    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"MATCH"
                                              dismissButtonTitles:[NSArray arrayWithObjects: @"OK", nil]
                                                    shouldAccept:YES];
    actual = [alert matchesAlertTitle:@"Found a match"];
    expect(actual).to.equal(YES);

    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"match"
                                              dismissButtonTitles:[NSArray arrayWithObjects: @"OK", nil]
                                                    shouldAccept:YES];
    actual = [alert matchesAlertTitle:@"Found a MATCH"];
    expect(actual).to.equal(YES);
}

@end

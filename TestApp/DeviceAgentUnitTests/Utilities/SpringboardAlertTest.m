
#import "CBXServerUnitTestUmbrellaHeader.h"
#import <Foundation/Foundation.h>
#import "SpringBoardAlerts.h"
#import "SpringBoardAlert.h"

@interface SpringBoardAlert (TEST)

- (instancetype)initWithAlertTitleFragment:(NSString *)matchText
                        dismissButtonTitle:(NSString *)acceptButtonTitle
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
                                              dismissButtonTitle:@"OK"
                                                    shouldAccept:YES];

    expect(alert.alertTitleFragment).to.equal(@"match");
    expect(alert.defaultDismissButtonMark).to.equal(@"OK");
    expect(alert.shouldAccept).to.equal(YES);

    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"match"
                                              dismissButtonTitle:@"Dismiss"
                                                    shouldAccept:NO];
    expect(alert.alertTitleFragment).to.equal(@"match");
    expect(alert.defaultDismissButtonMark).to.equal(@"Dismiss");
    expect(alert.shouldAccept).to.equal(NO);
}

- (void)testMatchesAlertTitle {
    SpringBoardAlert *alert;
    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"match"
                                              dismissButtonTitle:@"OK"
                                                    shouldAccept:YES];

    BOOL actual = [alert matchesAlertTitle:@"Found a match"];
    expect(actual).to.equal(YES);

    actual = [alert matchesAlertTitle:@"Not found"];
    expect(actual).to.equal(NO);

    // matching is done with lowercase strings
    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"MATCH"
                                              dismissButtonTitle:@"OK"
                                                    shouldAccept:YES];
    actual = [alert matchesAlertTitle:@"Found a match"];
    expect(actual).to.equal(YES);

    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"match"
                                              dismissButtonTitle:@"OK"
                                                    shouldAccept:YES];
    actual = [alert matchesAlertTitle:@"Found a MATCH"];
    expect(actual).to.equal(YES);
    
}

- (void)testMatchesAlertTitleWithRegex {
    SpringBoardAlert *alert;
    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"this is the %@ test"
                                              dismissButtonTitle:@"OK"
                                                    shouldAccept:YES];
    BOOL actual = [alert matchesAlertTitle:@"this is the regex test"];
    expect(actual).to.equal(YES);
    
    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"this is the %@ test"
                                              dismissButtonTitle:@"OK"
                                                    shouldAccept:YES];
    actual = [alert matchesAlertTitle:@"this is the REGEX test"];
    expect(actual).to.equal(YES);
    
    // matching is done with digits and dashes
    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"this is the %@ test"
                                              dismissButtonTitle:@"OK"
                                                    shouldAccept:YES];
    actual = [alert matchesAlertTitle:@"this is the Regex-5 test"];
    expect(actual).to.equal(YES);
    
    // matching is failed with anyone symbol else chars, digits and dashes
    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"this is the %@ test"
                                              dismissButtonTitle:@"OK"
                                                    shouldAccept:YES];
    actual = [alert matchesAlertTitle:@"this is the regex? test"];
    expect(actual).to.equal(NO);
}

- (void)testMatchesAlertTitleWithTwoArguments {
    SpringBoardAlert *alert;
    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"this is the %1$@ test"
                                              dismissButtonTitle:@"OK"
                                                    shouldAccept:YES];
    BOOL actual = [alert matchesAlertTitle:@"this is the regex test"];
    expect(actual).to.equal(YES);
    
    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"this is the %1$@ test with %2$@ arguments"
                                              dismissButtonTitle:@"OK"
                                                    shouldAccept:YES];
    actual = [alert matchesAlertTitle:@"this is the Regex test with two arguments"];
    expect(actual).to.equal(YES);
    
    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"this is the %1$@ test with %2$@ arguments"
                                              dismissButtonTitle:@"OK"
                                                    shouldAccept:YES];
    actual = [alert matchesAlertTitle:@"this is the -regex- test with 2 arguments"];
    expect(actual).to.equal(YES);
}

@end

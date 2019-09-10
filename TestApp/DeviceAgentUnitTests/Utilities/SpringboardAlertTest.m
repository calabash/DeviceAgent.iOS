
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

    expect(alert.alertTitleFragment).to.equal(@"^match$");
    expect(alert.defaultDismissButtonMarks).to.contain(@"OK");
    expect(alert.shouldAccept).to.equal(YES);

    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"match"
                                              dismissButtonTitles:[NSArray arrayWithObjects: @"Dismiss", nil]
                                                    shouldAccept:NO];
    expect(alert.alertTitleFragment).to.equal(@"^match$");
    expect(alert.defaultDismissButtonMarks).to.contain(@"Dismiss");
    expect(alert.shouldAccept).to.equal(NO);
}

- (void)testMatchesAlertTitle {
    SpringBoardAlert *alert;
    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"Found a match"
                                              dismissButtonTitles:[NSArray arrayWithObjects: @"OK", nil]
                                                    shouldAccept:YES];

    BOOL actual = [alert matchesAlertTitle:@"Found a match"];
    expect(actual).to.equal(YES);

    actual = [alert matchesAlertTitle:@"Not found"];
    expect(actual).to.equal(NO);

    // matching is done with lowercase strings
    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"Found a MATCH"
                                              dismissButtonTitles:[NSArray arrayWithObjects: @"OK", nil]
                                                    shouldAccept:YES];
    actual = [alert matchesAlertTitle:@"Found a match"];
    expect(actual).to.equal(YES);

    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"Found a match"
                                              dismissButtonTitles:[NSArray arrayWithObjects: @"OK", nil]
                                                    shouldAccept:YES];
    actual = [alert matchesAlertTitle:@"Found a MATCH"];
    expect(actual).to.equal(YES);
}

- (void)testMatchesAlertTitleWithRegex {
    SpringBoardAlert *alert;
    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"this is the %@ test"
                                              dismissButtonTitles:[NSArray arrayWithObjects: @"OK", nil]
                                                    shouldAccept:YES];
    BOOL actual = [alert matchesAlertTitle:@"this is the regex test"];
    expect(actual).to.equal(YES);

    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"%@ this is the test"
                                              dismissButtonTitles:[NSArray arrayWithObjects: @"OK", nil]
                                                    shouldAccept:YES];
    actual = [alert matchesAlertTitle:@"regex this is the test"];
    expect(actual).to.equal(YES);

    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"this is the test %@"
                                              dismissButtonTitles:[NSArray arrayWithObjects: @"OK", nil]
                                                    shouldAccept:YES];
    actual = [alert matchesAlertTitle:@"this is the test regex"];
    expect(actual).to.equal(YES);
    
    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"this is the %@ test"
                                              dismissButtonTitles:[NSArray arrayWithObjects: @"OK", nil]
                                                    shouldAccept:YES];
    actual = [alert matchesAlertTitle:@"this is the REGEX test"];
    expect(actual).to.equal(YES);
    
    // matching is done with digits and dashes
    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"this is the %@ test"
                                              dismissButtonTitles:[NSArray arrayWithObjects: @"OK", nil]
                                                    shouldAccept:YES];
    actual = [alert matchesAlertTitle:@"this is the Regex-5 test"];
    expect(actual).to.equal(YES);
    
    // matching is done with whitespace in program name
    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"this is the %@ test"
                                              dismissButtonTitles:[NSArray arrayWithObjects: @"OK", nil]
                                                    shouldAccept:YES];
    actual = [alert matchesAlertTitle:@"this is the white space test"];
    expect(actual).to.equal(YES);
}

- (void)testMatchesAlertTitleWithTwoArguments {
    SpringBoardAlert *alert;
    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"this is the %1$@ test"
                                              dismissButtonTitles:[NSArray arrayWithObjects: @"OK", nil]
                                                    shouldAccept:YES];
    BOOL actual = [alert matchesAlertTitle:@"this is the regex test"];
    expect(actual).to.equal(YES);
    
    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"this is the %1$@ test with %2$@ arguments"
                                              dismissButtonTitles:[NSArray arrayWithObjects: @"OK", nil]
                                                    shouldAccept:YES];
    actual = [alert matchesAlertTitle:@"this is the Regex test with two arguments"];
    expect(actual).to.equal(YES);

    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"%1$@ this is the test with %2$@ arguments"
                                              dismissButtonTitles:[NSArray arrayWithObjects: @"OK", nil]
                                                    shouldAccept:YES];
    actual = [alert matchesAlertTitle:@"Regex this is the test with two arguments"];
    expect(actual).to.equal(YES);

    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"%1$@ this is the test with arguments %2$@"
                                              dismissButtonTitles:[NSArray arrayWithObjects: @"OK", nil]
                                                    shouldAccept:YES];
    actual = [alert matchesAlertTitle:@"Regex this is the test with arguments two"];
    expect(actual).to.equal(YES);

    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"this is the %1$@ test with arguments %2$@"
                                              dismissButtonTitles:[NSArray arrayWithObjects: @"OK", nil]
                                                    shouldAccept:YES];
    actual = [alert matchesAlertTitle:@"this is the Regex test with arguments two"];
    expect(actual).to.equal(YES);
}

- (void)testMatchesAlertTitleWithSpecialChar {
    SpringBoardAlert *alert;
    alert = [[SpringBoardAlert alloc] initWithAlertTitleFragment:@"thi*s is? t[h]e %@ te+st."
                                              dismissButtonTitles:[NSArray arrayWithObjects: @"OK", nil]
                                                    shouldAccept:YES];
    BOOL actual = [alert matchesAlertTitle:@"thi*s is? t[h]e special-symbol te+st."];
    expect(actual).to.equal(YES);
    
}

@end


#import "CBXServerUnitTestUmbrellaHeader.h"
#import "SpringBoardAlerts.h"
#import "SpringBoardAlert.h"

#pragma mark - PrivacyAlerts

@interface SpringBoardAlerts(TEST)
+ (void)raiseIfInvalidAlert:(NSDictionary *)alertDict
                 ofLanguage:(NSString*)language
                andPosition:(NSInteger)position;
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

    alertTitle = @"« l'application » souhaite accéder à vos rappels.";
    expectedButton = @"OK";
    expectedShouldAccept = YES;
    actual = [[SpringBoardAlerts shared] alertMatchingTitle:alertTitle];

    expect(actual.defaultDismissButtonMarks).to.contain(expectedButton);
    expect(actual.shouldAccept).to.equal(expectedShouldAccept);

    alertTitle = @"Разрешить ресурсу «Ресурс» доступ к Вашей геопозиции?";
    expectedButton = @"Разрешить";
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
    expectedShouldAccept = YES;
    actual = [[SpringBoardAlerts shared] alertMatchingTitle:alertTitle];

    expect(actual.defaultDismissButtonMarks).to.contain(expectedButton);
    expect(actual.shouldAccept).to.equal(expectedShouldAccept);

    alertTitle = @"Permitir que “la aplicación” tenha acesso à sua localização mesmo quando você não estiver usando o app?";
    expectedButton = @"Permitir";
    expectedShouldAccept = YES;
    actual = [[SpringBoardAlerts shared] alertMatchingTitle:alertTitle];

    expect(actual.defaultDismissButtonMarks).to.contain(expectedButton);
    expect(actual.shouldAccept).to.equal(expectedShouldAccept);

    alertTitle = @"Open in “Internet Explorer 6”?";
    expectedButton = @"Open";
    expectedShouldAccept = YES;
    actual = [[SpringBoardAlerts shared] alertMatchingTitle:alertTitle];

    expect(actual.defaultDismissButtonMarks).to.contain(expectedButton);
    expect(actual.shouldAccept).to.equal(expectedShouldAccept);
    
    alertTitle = @"“AppName” Would Like Access to Twitter Accounts";
    expectedButton = @"OK";
    expectedShouldAccept = YES;
    actual = [[SpringBoardAlerts shared] alertMatchingTitle:alertTitle];

    expect(actual.defaultDismissButtonMarks).to.contain(expectedButton);
    expect(actual.shouldAccept).to.equal(expectedShouldAccept);
    
    alertTitle = @"‘합니다’에서 네트워크 콘텐츠를 필터링하려고 합니다.";
    expectedButton = @"허용";
    expectedShouldAccept = YES;
    actual = [[SpringBoardAlerts shared] alertMatchingTitle:alertTitle];

    expect(actual.defaultDismissButtonMarks).to.contain(expectedButton);
    expect(actual.shouldAccept).to.equal(expectedShouldAccept);
    
    alertTitle = @"«Прiложение» хоче фільтрувати мережевий контент";
    expectedButton = @"Дозволити";
    expectedShouldAccept = YES;
    actual = [[SpringBoardAlerts shared] alertMatchingTitle:alertTitle];

    expect(actual.defaultDismissButtonMarks).to.contain(expectedButton);
    expect(actual.shouldAccept).to.equal(expectedShouldAccept);
}

- (void)testAlertValidation {
    NSDictionary *alertWithoutTitle = @{
                                        @"buttons": @[[NSObject alloc]],
                                        @"shouldAccept": @(YES)
                                        };
    expect(^{
        [SpringBoardAlerts raiseIfInvalidAlert:alertWithoutTitle
                                    ofLanguage:@"foo"
                                   andPosition:-1];
    }).to.raise(@"Bad springboard-alerts JSON");

    @try {
        [SpringBoardAlerts raiseIfInvalidAlert:alertWithoutTitle
                                    ofLanguage:@"foo"
                                   andPosition:-1];
    } @catch (NSException *e) {
        expect(e.reason).to.equal(@"No title");
        expect(e.userInfo[@"language"]).to.equal(@"foo");
        expect(e.userInfo[@"position"]).to.equal(-1);
        expect(e.userInfo[@"alert"]).to.equal(alertWithoutTitle);
    }

    NSDictionary* alertWithoutButtons = @{
                                          @"title": @"some",
                                          @"shouldAccept": @(YES)
                                          };
    expect(^{
        [SpringBoardAlerts raiseIfInvalidAlert:alertWithoutButtons
                                    ofLanguage:@"foo"
                                   andPosition:-1];
    }).to.raise(@"Bad springboard-alerts JSON");

    @try {
        [SpringBoardAlerts raiseIfInvalidAlert:alertWithoutButtons
                                    ofLanguage:@"foo"
                                   andPosition:-1];
    } @catch (NSException *e) {
        expect(e.reason).to.equal(@"No buttons");
        expect(e.userInfo[@"language"]).to.equal(@"foo");
        expect(e.userInfo[@"position"]).to.equal(-1);
        expect(e.userInfo[@"alert"]).to.equal(alertWithoutButtons);
    }

    NSDictionary* alertWithZeroButtons = @{
                                           @"title": @"some",
                                           @"buttons": @[],
                                           @"shouldAccept": @(YES)
                                           };
    expect(^{
        [SpringBoardAlerts raiseIfInvalidAlert:alertWithZeroButtons
                                    ofLanguage:@"foo"
                                   andPosition:-1];
    }).to.raise(@"Bad springboard-alerts JSON");

    @try {
        [SpringBoardAlerts raiseIfInvalidAlert:alertWithZeroButtons
                                    ofLanguage:@"foo"
                                   andPosition:-1];
    } @catch (NSException *e) {
        expect(e.reason).to.equal(@"Zero size buttons array");
        expect(e.userInfo[@"language"]).to.equal(@"foo");
        expect(e.userInfo[@"position"]).to.equal(-1);
        expect(e.userInfo[@"alert"]).to.equal(alertWithZeroButtons);
    }

    NSDictionary* alertWithoutShouldAccept = @{
                                               @"title": @"some",
                                               @"buttons": @[[NSObject alloc]]
                                               };
    expect(^{
        [SpringBoardAlerts raiseIfInvalidAlert:alertWithoutShouldAccept
                                    ofLanguage:@"foo"
                                   andPosition:-1];
    }).to.raise(@"Bad springboard-alerts JSON");

    @try {
        [SpringBoardAlerts raiseIfInvalidAlert:alertWithoutShouldAccept
                                    ofLanguage:@"foo"
                                   andPosition:-1];
    } @catch (NSException *e) {
        expect(e.reason).to.equal(@"No shouldAccept");
        expect(e.userInfo[@"language"]).to.equal(@"foo");
        expect(e.userInfo[@"position"]).to.equal(-1);
        expect(e.userInfo[@"alert"]).to.equal(alertWithoutShouldAccept);
    }
}

@end

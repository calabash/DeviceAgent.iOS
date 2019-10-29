
#import "CBXServerUnitTestUmbrellaHeader.h"
#import "SpringBoardAlerts.h"
#import "SpringBoardAlert.h"

#pragma mark - PrivacyAlerts

@interface SpringBoardAlerts(TEST)
+ (void)raiseIfInvalidAlert:(NSDictionary *)alertDict
                 ofLanguage:(NSString*)language
                andPosition:(NSInteger)position;
- (NSMutableArray<SpringBoardAlert *> *)alerts;
- (instancetype)init_private;
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

- (void)testAlertTitleNil {
    NSString *alertTitle = @"Some alert generated SpringBoard that we cannot handle";
    SpringBoardAlert *actual = [[SpringBoardAlerts shared] alertMatchingTitle:alertTitle];

    expect(actual).to.equal(nil);
}

- (void)testAlertTitleFr_Ca {
    id localeMock = OCMClassMock([NSLocale class]);
    NSArray<NSString *> * array = [NSArray arrayWithObject:@"fr-CA"];
    OCMStub([localeMock preferredLanguages]).andReturn(array);
    SpringBoardAlerts *alertsArray = [[SpringBoardAlerts alloc] init_private];
    
    NSString *alertTitle = @"« l'application » souhaite accéder à vos rappels.";
    NSString *expectedButton = @"OK";
    BOOL expectedShouldAccept = YES;
    SpringBoardAlert *actual = [alertsArray alertMatchingTitle:alertTitle];

    expect(actual.defaultDismissButtonMarks).to.contain(expectedButton);
    expect(actual.shouldAccept).to.equal(expectedShouldAccept);
    
    [localeMock stopMocking];
}

- (void)testAlertTitleRu {
    id localeMock = OCMClassMock([NSLocale class]);
    NSArray<NSString *> * array = [NSArray arrayWithObject:@"ru"];
    OCMStub([localeMock preferredLanguages]).andReturn(array);
    SpringBoardAlerts *alertsArray = [[SpringBoardAlerts alloc] init_private];

    NSString *alertTitle = @"Разрешить ресурсу «Ресурс» доступ к Вашей геопозиции?";
    NSString *expectedButton = @"Разрешить";
    BOOL expectedShouldAccept = YES;
    SpringBoardAlert *actual = [alertsArray alertMatchingTitle:alertTitle];

    expect(actual.defaultDismissButtonMarks).to.contain(expectedButton);
    expect(actual.shouldAccept).to.equal(expectedShouldAccept);
    
    [localeMock stopMocking];
}

- (void)testAlertTitleEn {
    id localeMock = OCMClassMock([NSLocale class]);
    NSArray<NSString *> * array = [NSArray arrayWithObject:@"en"];
    OCMStub([localeMock preferredLanguages]).andReturn(array);
    
    NSString *alertTitle = @"No SIM Card Installed";
    NSString *expectedButton = @"OK";
    BOOL expectedShouldAccept = YES;
    SpringBoardAlert *actual = [[SpringBoardAlerts shared] alertMatchingTitle:alertTitle];

    expect(actual.defaultDismissButtonMarks).to.contain(expectedButton);
    expect(actual.shouldAccept).to.equal(expectedShouldAccept);
    
    [localeMock stopMocking];
}

- (void)testAlertTitleEn_Au {
    id localeMock = OCMClassMock([NSLocale class]);
    NSArray<NSString *> * array = [NSArray arrayWithObject:@"en-AU"];
    OCMStub([localeMock preferredLanguages]).andReturn(array);
    
    NSString *alertTitle = @"Carrier Settings Update";
    NSString *expectedButton = @"Not Now";
    BOOL expectedShouldAccept = NO;
    SpringBoardAlert *actual = [[SpringBoardAlerts shared] alertMatchingTitle:alertTitle];

    expect(actual.defaultDismissButtonMarks).to.contain(expectedButton);
    expect(actual.shouldAccept).to.equal(expectedShouldAccept);
    
    [localeMock stopMocking];
}

- (void)testAlertTitlePt {
    id localeMock = OCMClassMock([NSLocale class]);
    NSArray<NSString *> * array = [NSArray arrayWithObject:@"pt"];
    OCMStub([localeMock preferredLanguages]).andReturn(array);
    SpringBoardAlerts *alertsArray = [[SpringBoardAlerts alloc] init_private];

    NSString *alertTitle = @"Permitir que “la aplicación” tenha acesso à sua localização mesmo quando você não estiver usando o app?";
    NSString *expectedButton = @"Permitir";
    BOOL expectedShouldAccept = YES;
    SpringBoardAlert *actual = [alertsArray alertMatchingTitle:alertTitle];

    expect(actual.defaultDismissButtonMarks).to.contain(expectedButton);
    expect(actual.shouldAccept).to.equal(expectedShouldAccept);
    
    [localeMock stopMocking];
}

- (void)testAlertTitleEn_Au_with_Regex {
    id localeMock = OCMClassMock([NSLocale class]);
    NSArray<NSString *> * array = [NSArray arrayWithObject:@"en-AU"];
    OCMStub([localeMock preferredLanguages]).andReturn(array);
    
    NSString *alertTitle = @"Open in “Internet Explorer 6”?";
    NSString *expectedButton = @"Open";
    BOOL expectedShouldAccept = YES;
    SpringBoardAlert *actual = [[SpringBoardAlerts shared] alertMatchingTitle:alertTitle];

    expect(actual.defaultDismissButtonMarks).to.contain(expectedButton);
    expect(actual.shouldAccept).to.equal(expectedShouldAccept);
    
    [localeMock stopMocking];
}
- (void)testAlertTitleKo {
    id localeMock = OCMClassMock([NSLocale class]);
    NSArray<NSString *> * array = [NSArray arrayWithObject:@"ko"];
    OCMStub([localeMock preferredLanguages]).andReturn(array);
    SpringBoardAlerts *alertsArray = [[SpringBoardAlerts alloc] init_private];

    NSString *alertTitle = @"‘합니다’에서 네트워크 콘텐츠를 필터링하려고 합니다.";
    NSString *expectedButton = @"허용 안 함";
    BOOL expectedShouldAccept = NO;
    SpringBoardAlert *actual = [alertsArray alertMatchingTitle:alertTitle];

    expect(actual.defaultDismissButtonMarks).to.contain(expectedButton);
    expect(actual.shouldAccept).to.equal(expectedShouldAccept);
    
    [localeMock stopMocking];
}

- (void)testAlertTitleUk {
    id localeMock = OCMClassMock([NSLocale class]);
    NSArray<NSString *> * array = [NSArray arrayWithObject:@"uk"];
    OCMStub([localeMock preferredLanguages]).andReturn(array);
    SpringBoardAlerts *alertsArray = [[SpringBoardAlerts alloc] init_private];

    NSString *alertTitle = @"«Прiложение» хоче фільтрувати мережевий контент";
    NSString *expectedButton = @"Дозволити";
    BOOL expectedShouldAccept = YES;
    SpringBoardAlert *actual = [alertsArray alertMatchingTitle:alertTitle];

    expect(actual.defaultDismissButtonMarks).to.contain(expectedButton);
    expect(actual.shouldAccept).to.equal(expectedShouldAccept);
    
    [localeMock stopMocking];
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

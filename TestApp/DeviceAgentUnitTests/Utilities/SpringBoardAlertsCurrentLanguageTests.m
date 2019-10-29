#import "CBXServerUnitTestUmbrellaHeader.h"
#import "SpringBoardAlerts.h"
#import "SpringBoardAlert.h"
#import <XCTest/XCTest.h>

@interface SpringBoardAlerts(TEST)
- (NSMutableArray<SpringBoardAlert *> *)alerts;
- (instancetype)init_private;

@end

@interface SpringBoardAlertsCurrentLanguageTests : XCTestCase
@property(nonatomic, strong) SpringBoardAlerts *testSpringBoardAlerts;
@end

@implementation SpringBoardAlertsCurrentLanguageTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (BOOL)containsLanguage:(NSString*)preferredLanguage
                    :(SpringBoardAlerts*)alertsArray {
    for(SpringBoardAlert *alert in alertsArray.alerts){
        if([alert matchesAlertTitle: preferredLanguage]){
            return YES;
        }
    }
    return NO;
}

- (void)testCurrentLanguageEn {
    id localeMock = OCMClassMock([NSLocale class]);
    NSArray<NSString *> * array = [NSArray arrayWithObject:@"en-US"];
    OCMStub([localeMock preferredLanguages]).andReturn(array);
    SpringBoardAlerts *alertsArray = [[SpringBoardAlerts alloc] init_private];
    
    expect([self containsLanguage:@"“%@” would like to make data available to nearby Bluetooth devices even when you’re not using the app.":alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"Программа «%@» запрашивает доступ к «Напоминаниям».":alertsArray]).to.beFalsy();

    [localeMock stopMocking];
}

- (void)testCurrentLanguageFrAny {
    id localeMock = OCMClassMock([NSLocale class]);
    NSArray<NSString *> * array = [NSArray arrayWithObject:@"fr-Any"];
    OCMStub([localeMock preferredLanguages]).andReturn(array);
    SpringBoardAlerts *alertsArray = [[SpringBoardAlerts alloc] init_private];
    
    expect([self containsLanguage:@"« %@ » souhaite accéder à vos mouvements et vos activités physiques.":alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"“%@” would like to make data available to nearby Bluetooth devices even when you’re not using the app.":alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"Программа «%@» запрашивает доступ к «Напоминаниям».":alertsArray]).to.beFalsy();

    [localeMock stopMocking];
}

- (void)testCurrentLanguageFrAnyEct {
    id localeMock = OCMClassMock([NSLocale class]);
    NSArray<NSString *> * array = [NSArray arrayWithObject:@"fr-Any-ect-etr"];
    OCMStub([localeMock preferredLanguages]).andReturn(array);
    SpringBoardAlerts *alertsArray = [[SpringBoardAlerts alloc] init_private];
    
    expect([self containsLanguage:@"« %@ » souhaite accéder à vos mouvements et vos activités physiques.":alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"“%@” would like to make data available to nearby Bluetooth devices even when you’re not using the app.":alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"Программа «%@» запрашивает доступ к «Напоминаниям».":alertsArray]).to.beFalsy();

    [localeMock stopMocking];
}

- (void)testCurrentLanguagezh_CN {
    id localeMock = OCMClassMock([NSLocale class]);
    NSArray<NSString *> * array = [NSArray arrayWithObject:@"zh-CN"];
    OCMStub([localeMock preferredLanguages]).andReturn(array);
    SpringBoardAlerts *alertsArray = [[SpringBoardAlerts alloc] init_private];
    
    expect([self containsLanguage:@"允许“%@”在您并未使用该应用时访问您的位置吗？":alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"“%@” would like to make data available to nearby Bluetooth devices even when you’re not using the app.":alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"Программа «%@» запрашивает доступ к «Напоминаниям».":alertsArray]).to.beFalsy();

    [localeMock stopMocking];
}

- (void)testCurrentLanguagezh_Hans_US {
    id localeMock = OCMClassMock([NSLocale class]);
    NSArray<NSString *> * array = [NSArray arrayWithObject:@"zh-Hans-US"];
    OCMStub([localeMock preferredLanguages]).andReturn(array);
    SpringBoardAlerts *alertsArray = [[SpringBoardAlerts alloc] init_private];
    
    expect([self containsLanguage:@"允许“%@”在您并未使用该应用时访问您的位置吗？":alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"“%@” would like to make data available to nearby Bluetooth devices even when you’re not using the app.":alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"Программа «%@» запрашивает доступ к «Напоминаниям».":alertsArray]).to.beFalsy();

    [localeMock stopMocking];
}

- (void)testCurrentLanguagezh_HK {
    id localeMock = OCMClassMock([NSLocale class]);
    NSArray<NSString *> * array = [NSArray arrayWithObject:@"zh-HK"];
    OCMStub([localeMock preferredLanguages]).andReturn(array);
    SpringBoardAlerts *alertsArray = [[SpringBoardAlerts alloc] init_private];
    
    expect([self containsLanguage:@"「%@」要取用你的提醒事項":alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"“%@” would like to make data available to nearby Bluetooth devices even when you’re not using the app.":alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"Программа «%@» запрашивает доступ к «Напоминаниям».":alertsArray]).to.beFalsy();

    [localeMock stopMocking];
}

- (void)testCurrentLanguagezh_Hant_HK {
    id localeMock = OCMClassMock([NSLocale class]);
    NSArray<NSString *> * array = [NSArray arrayWithObject:@"zh-Hant-HK"];
    OCMStub([localeMock preferredLanguages]).andReturn(array);
    SpringBoardAlerts *alertsArray = [[SpringBoardAlerts alloc] init_private];
    
    expect([self containsLanguage:@"「%@」要取用你的提醒事項":alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"“%@” would like to make data available to nearby Bluetooth devices even when you’re not using the app.":alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"Программа «%@» запрашивает доступ к «Напоминаниям».":alertsArray]).to.beFalsy();

    [localeMock stopMocking];
}

- (void)testCurrentLanguagezh_TW {
    id localeMock = OCMClassMock([NSLocale class]);
    NSArray<NSString *> * array = [NSArray arrayWithObject:@"zh-TW"];
    OCMStub([localeMock preferredLanguages]).andReturn(array);
    SpringBoardAlerts *alertsArray = [[SpringBoardAlerts alloc] init_private];
    
    expect([self containsLanguage:@"要允許「%@」在您使用 App 時取用您的位置嗎？":alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"“%@” would like to make data available to nearby Bluetooth devices even when you’re not using the app.":alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"Программа «%@» запрашивает доступ к «Напоминаниям».":alertsArray]).to.beFalsy();

    [localeMock stopMocking];
}

- (void)testCurrentLanguagezh_Hant_US {
    id localeMock = OCMClassMock([NSLocale class]);
    NSArray<NSString *> * array = [NSArray arrayWithObject:@"zh-Hant-US"];
    OCMStub([localeMock preferredLanguages]).andReturn(array);
    SpringBoardAlerts *alertsArray = [[SpringBoardAlerts alloc] init_private];
    
    expect([self containsLanguage:@"要允許「%@」在您使用 App 時取用您的位置嗎？":alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"“%@” would like to make data available to nearby Bluetooth devices even when you’re not using the app.":alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"Программа «%@» запрашивает доступ к «Напоминаниям».":alertsArray]).to.beFalsy();

    [localeMock stopMocking];
}

- (void)testCurrentLanguageptPt {
    id localeMock = OCMClassMock([NSLocale class]);
    NSArray<NSString *> * array = [NSArray arrayWithObject:@"pt-PT"];
    OCMStub([localeMock preferredLanguages]).andReturn(array);
    SpringBoardAlerts *alertsArray = [[SpringBoardAlerts alloc] init_private];
    
    expect([self containsLanguage:@"“%@” Deseja Ter Acesso aos Seus Contatos": alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"“%@” Would Like to Send You Push Notifications":alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"Программа «%@» запрашивает доступ к «Напоминаниям».":alertsArray]).to.beFalsy();

    [localeMock stopMocking];
}

- (void)testCurrentLanguageRu {
    id localeMock = OCMClassMock([NSLocale class]);
    NSArray<NSString *> * array = [NSArray arrayWithObject:@"ru"];
    OCMStub([localeMock preferredLanguages]).andReturn(array);
    SpringBoardAlerts *alertsArray = [[SpringBoardAlerts alloc] init_private];
    
    expect([self containsLanguage:@"Программа «%@» запрашивает доступ к «Контактам».": alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"Sign In to iTunes Store":alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"« %@ » souhaite accéder à vos mouvements et vos activités physiques.":alertsArray]).to.beFalsy();

    [localeMock stopMocking];
}

- (void)testCurrentLanguageUnExisting {
    id localeMock = OCMClassMock([NSLocale class]);
    NSArray<NSString *> * array = [NSArray arrayWithObject:@"ÿyyyyyyy"];
    OCMStub([localeMock preferredLanguages]).andReturn(array);
    SpringBoardAlerts *alertsArray = [[SpringBoardAlerts alloc] init_private];
    
    expect([self containsLanguage:@"Программа «%@» запрашивает доступ к «Контактам».": alertsArray]).to.beFalsy();
    expect([self containsLanguage:@"Sign In to iTunes Store":alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"« %@ » souhaite accéder à vos mouvements et vos activités physiques.":alertsArray]).to.beFalsy();

    [localeMock stopMocking];
}

- (void)testCurrentLanguageEs {
    id localeMock = OCMClassMock([NSLocale class]);
    NSArray<NSString *> * array = [NSArray arrayWithObject:@"es"];
    OCMStub([localeMock preferredLanguages]).andReturn(array);
    SpringBoardAlerts *alertsArray = [[SpringBoardAlerts alloc] init_private];
    
    expect([self containsLanguage:@"“%@” quiere acceder al reconocimiento de voz": alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"Sign In to iTunes Store":alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"acceda a tu ubicación incluso cuando la app no está en uso":alertsArray]).to.beFalsy();

    [localeMock stopMocking];
}

- (void)testCurrentLanguageEs_419 {
    id localeMock = OCMClassMock([NSLocale class]);
    NSArray<NSString *> * array = [NSArray arrayWithObject:@"es-419"];
    OCMStub([localeMock preferredLanguages]).andReturn(array);
    SpringBoardAlerts *alertsArray = [[SpringBoardAlerts alloc] init_private];
    
    expect([self containsLanguage:@"“%@” quiere acceder a tu condición y actividad física": alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"Sign In to iTunes Store":alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"“%@” quiere acceder al reconocimiento de voz":alertsArray]).to.beTruthy();

    [localeMock stopMocking];
}

- (void)testCurrentLanguageHe {
    id localeMock = OCMClassMock([NSLocale class]);
    NSArray<NSString *> * array = [NSArray arrayWithObject:@"he"];
    OCMStub([localeMock preferredLanguages]).andReturn(array);
    SpringBoardAlerts *alertsArray = [[SpringBoardAlerts alloc] init_private];
    
    expect([self containsLanguage:@"״%@״ מעוניין לגשת למשימות שלך": alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"Sign In to iTunes Store":alertsArray]).to.beTruthy();
    expect([self containsLanguage:@"« %@ » souhaite accéder à vos mouvements et vos activités physiques.":alertsArray]).to.beFalsy();

    [localeMock stopMocking];
}

@end

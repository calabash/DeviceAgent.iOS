
#import "SpringBoardAlerts.h"
#import "SpringBoardAlert.h"


// Convenience method for creating alerts from the regular expressions found in run_loop
// scripts/lib/on_alert.js
static SpringBoardAlert *alert(NSString *buttonTitle, BOOL shouldAccept, NSString *title) {
    return [[SpringBoardAlert alloc] initWithAlertTitleFragment:title
                                             dismissButtonTitle:buttonTitle
                                                   shouldAccept:shouldAccept];
}

@interface SpringBoardAlerts ()

@property(strong) NSArray<SpringBoardAlert *> *alerts;

- (instancetype)init_private;
- (NSArray<SpringBoardAlert *> *)concatenateArrays:(NSArray<NSArray *> *)arrays;
- (NSArray<SpringBoardAlert *> *)USEnglishAlerts;
- (NSArray<SpringBoardAlert *> *)DanishAlerts;
- (NSArray<SpringBoardAlert *> *)DutchAlerts;
- (NSArray<SpringBoardAlert *> *)DutchAlerts_BE;
- (NSArray<SpringBoardAlert *> *)SwedishAlerts;
- (NSArray<SpringBoardAlert *> *)GermanAlerts;
- (NSArray<SpringBoardAlert *> *)EUSpanishAlerts;
- (NSArray<SpringBoardAlert *> *)ES419SpanishAlerts;
- (NSArray<SpringBoardAlert *> *)FrenchAlerts;
- (NSArray<SpringBoardAlert *> *)RussianAlerts;
- (NSArray<SpringBoardAlert *> *)PTBrazilAlerts;
- (NSArray<SpringBoardAlert *> *)KoreanAlerts;

@end

@implementation SpringBoardAlerts

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Cannot call init"
                                   reason:@"This is a singleton class"
                                 userInfo:nil];
}

- (instancetype)init_private {
    self = [super init];
    if (self) {
        _alerts = [self concatenateArrays:@[
                                            [self USEnglishAlerts],
                                            [self DanishAlerts],
                                            [self DutchAlerts],
                                            [self DutchAlerts_BE],
                                            [self SwedishAlerts],
                                            [self EUSpanishAlerts],
                                            [self ES419SpanishAlerts],
                                            [self GermanAlerts],
                                            [self FrenchAlerts],
                                            [self RussianAlerts],
                                            [self PTBrazilAlerts],
                                            [self KoreanAlerts]
                                            ]];
    }
    return self;
}

+ (SpringBoardAlerts *)shared {
    static SpringBoardAlerts *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[SpringBoardAlerts alloc] init_private];
    });
    return shared;
}


- (SpringBoardAlert *)alertMatchingTitle:(NSString *)alertTitle {

    __block SpringBoardAlert *match = nil;
    [self.alerts enumerateObjectsUsingBlock:^(SpringBoardAlert *alert, NSUInteger idx, BOOL *stop) {
        if ([alert matchesAlertTitle:alertTitle]) {
            match = alert;
            *stop = YES;
        }
    }];

    return match;
}

- (NSArray<SpringBoardAlert *> *)concatenateArrays:(NSArray<NSArray *> *)arrays {
    __block NSArray *final = @[];
    [arrays enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger idx, BOOL *stop) {
        final = [final arrayByAddingObjectsFromArray:array];
    }];
    return final;
}

- (NSArray<SpringBoardAlert *> *)USEnglishAlerts {
    return @[
             alert(@"OK", YES, @"Would Like to Use Your Current Location"),
             alert(@"OK", YES, @"Location Accuracy"),
             alert(@"Allow", YES, @"access your location"),
             alert(@"OK", YES, @"Health Access"),
             alert(@"OK", YES, @"Would Like to Access Your Photos"),
             alert(@"OK", YES, @"Would Like to Access Your Contacts"),
             alert(@"OK", YES, @"Access the Microphone"),
             alert(@"OK", YES, @"Would Like to Access Your Calendar"),
             alert(@"OK", YES, @"Would Like to Access Your Reminders"),
             alert(@"OK", YES, @"Would Like to Access Your Motion Activity"),
             alert(@"OK", YES, @"Would Like to Access the Camera"),
             alert(@"OK", YES, @"Would Like to Access Your Motion & Fitness Activity"),
             alert(@"OK", YES, @"Would Like Access to Twitter Accounts"),
             alert(@"OK", YES, @"data available to nearby bluetooth devices"),
             alert(@"OK", YES, @"Would Like to Send You Push Notifications"),
             alert(@"OK", YES, @"Would Like to Send You Notifications"),
             alert(@"OK", YES, @"No SIM Card Installed"),
             alert(@"Not Now", NO, @"Carrier Settings Update"),
             alert(@"Not Now", NO, @"Enable Dictation?"),
             alert(@"Cancel", NO, @"Sign In to iTunes Store"),
             alert(@"OK", YES, @"Would Like to Access Apple Music And Your Media Library"),
             alert(@"Allow", YES, @"Would Like to Add VPN Configurations"),
             alert(@"Open", YES, @"Open in")
             ];
}

- (NSArray<SpringBoardAlert *> *)DanishAlerts {
    return @[
             alert(@"Tillad", YES, @"bruge din lokalitet, når du bruger appen"),
             alert(@"Tillad", YES, @"også når du ikke bruger appen"),
             alert(@"OK", YES, @"vil bruge din aktuelle placering"),
             alert(@"OK", YES, @"vil bruge dine kontakter"),
             alert(@"OK", YES, @"vil bruge mikrofonen"),
             alert(@"OK", YES, @"vil bruge din kalender"),
             alert(@"OK", YES, @"vil bruge dine påmindelser"),
             alert(@"OK", YES, @"vil bruge dine fotos"),
             alert(@"OK", YES, @"ønsker adgang til Twitter-konti"),
             alert(@"OK", YES, @"vil bruge din fysiske aktivitet og din træningsaktivitet"),
             alert(@"OK", YES, @"vil bruge kameraet"),
             alert(@"OK", YES, @"vil gerne sende dig meddelelser"),
             alert(@"Åbn", YES, @"Åbn i")
             ];
}

- (NSArray<SpringBoardAlert *> *)DutchAlerts {
    return @[
             alert(@"Sta toe", YES, @"tot uw locatie toestaan terwijl u de app gebruikt"),
             alert(@"Sta toe", YES, @"toegang tot uw locatie toestaan terwijl u de app gebruikt"),
             alert(@"Sta toe", YES, @"ook toegang tot uw locatie toestaan, zelfs als u de app niet gebruikt"),
             alert(@"Sta toe", YES, @"toegang tot uw locatie toestaan, zelfs als u de app niet gebruikt"),
             alert(@"OK", YES, @"wil toegang tot uw contacten"),
             alert(@"OK", YES, @"wil toegang tot uw agenda"),
             alert(@"OK", YES, @"wil toegang tot uw herinneringen"),
             alert(@"OK", YES, @"wil toegang tot uw foto's"),
             alert(@"OK", YES, @"wil toegang tot Twitter-accounts"),
             alert(@"OK", YES, @"wil toegang tot de microfoon"),
             alert(@"OK", YES, @"wil toegang tot uw bewegings- en fitnessactiviteit"),
             alert(@"OK", YES, @"wil toegang tot de camera"),
             alert(@"OK", YES, @"wil u berichten sturen"),
             alert(@"Open", YES, @"Openen met")
             ];
}

- (NSArray<SpringBoardAlert *> *)DutchAlerts_BE {
    return @[
             alert(@"Sta toe", YES, @"toegang tot je locatie toestaan terwijl je de app gebruikt"),
             alert(@"Sta toe", YES, @"toegang tot je locatie toestaan, zelfs als je de app niet gebruikt"),
             alert(@"OK", YES, @"wil toegang tot je contacten"),
             alert(@"OK", YES, @"wil toegang tot je agenda"),
             alert(@"OK", YES, @"wil toegang tot je herinneringen"),
             alert(@"OK", YES, @"wil toegang tot je foto's"),
             alert(@"OK", YES, @"wil toegang tot Twitter-accounts"),
             alert(@"OK", YES, @"wil toegang tot de microfoon"),
             alert(@"OK", YES, @"wil toegang tot je bewegings- en fitnessactiviteit"),
             alert(@"OK", YES, @"wil toegang tot de camera")
             ];
}

- (NSArray<SpringBoardAlert *> *)SwedishAlerts {
    return @[
             alert(@"Tillåt", YES, @"att se din platsinfo när du använder appen"),
             alert(@"Tillåt", YES, @"även ser din platsinfo när du inte använder appen"),
             alert(@"Tillåt", YES, @"att se din platsinfo även när du inte använder appen"),
             alert(@"OK", YES, @"begär åtkomst till dina kontakter"),
             alert(@"OK", YES, @"begär åtkomst till din kalender"),
             alert(@"OK", YES, @"begär åtkomst till dina påminnelser"),
             alert(@"OK", YES, @"begär åtkomst till dina bilder"),
             alert(@"OK", YES, @"vill komma åt dina Twitter-konton"),
             alert(@"OK", YES, @"begär åtkomst till mikrofonen"),
             alert(@"OK", YES, @"begär åtkomst till din rörelse- och träningsaktivitet"),
             alert(@"OK", YES, @"begär åtkomst till kameran"),
             alert(@"Tillåt", YES, @"vill skicka notiser till dig"),
             alert(@"Öppna", YES, @"Öppna i")
             ];
}
- (NSArray<SpringBoardAlert *> *)GermanAlerts {
    return @[
             alert(@"Ja", YES, @"Ihren aktuellen Ort verwenden"),
             alert(@"Erlauben", YES, @"auf Ihren Standort zugreifen, wenn Sie die App benutzen"),
             alert(@"Erlauben", YES, @"auch auf Ihren Standort zugreifen, wenn Sie die App nicht benutzen"),
             alert(@"Erlauben", YES, @"auf Ihren Standort zugreifen, selbst wenn Sie die App nicht benutzen"),
             alert(@"Ja", YES, @"auf Ihre Kontakte zugreifen"),
             alert(@"Ja", YES, @"auf Ihren Kalender zugreifen"),
             alert(@"Ja", YES, @"auf Ihre Erinnerungen zugreifen"),
             alert(@"Ja", YES, @"auf Ihre Fotos zugreifen"),
             alert(@"OK", YES, @"möchte auf deine Fotos zugreifen"),
             alert(@"Erlauben", YES, @"möchte auf Twitter-Accounts zugreifen"),
             alert(@"Ja", YES, @"auf das Mikrofon zugreifen"),
             alert(@"Ja", YES, @"möchte auf Ihre Bewegungs- und Fitnessdaten zugreifen"),
             alert(@"Ja", YES, @"auf Ihre Kamera zugreifen"),
             alert(@"OK", YES, @"Ihnen Mitteilungen senden"),
             alert(@"OK", YES, @"Keine SIM-Karte eingelegt"),
             alert(@"Öffnen", YES, @"öffnen?")
             ];
}

- (NSArray<SpringBoardAlert *> *)EUSpanishAlerts {
    return @[
             alert(@"Permitir", YES, @"acceder a tu ubicación mientras utilizas la aplicación"),
             alert(@"Permitir", YES, @"acceder a tu ubicación aunque no estés utilizando la aplicación"),
             alert(@"OK", YES, @"quiere acceder a tus contactos"),
             alert(@"OK", YES, @"quiere acceder a tu calendario"),
             alert(@"OK", YES, @"quiere acceder a tus recordatorios"),
             alert(@"OK", YES, @"quiere acceder a tus fotos"),
             alert(@"OK", YES, @"quiere obtener acceso a cuentas Twitter"),
             alert(@"OK", YES, @"quiere acceder al micrófono"),
             alert(@"OK", YES, @"desea acceder a tu actividad física y deportiva"),
             alert(@"OK", YES, @"quiere acceder a la cámara"),
             alert(@"OK", YES, @"quiere enviarte notificaciones"),
             alert(@"Abrir", YES, @"¿Abrir en")
             ];
}

- (NSArray<SpringBoardAlert *> *)ES419SpanishAlerts {
    return @[
             alert(@"Permitir", YES, @"acceda a tu ubicación mientras la app está en uso"),
             alert(@"Permitir", YES, @"acceda a tu ubicación incluso cuando la app no está en uso"),
             alert(@"OK", YES, @"quiere acceder a tu condición y actividad física")
             ];
}

- (NSArray<SpringBoardAlert *> *)FrenchAlerts {
    return @[
             alert(@"OK", YES, @"vous envoyer des notifications"),
             alert(@"Autoriser", YES, @"à accéder à vos données de localisation lorsque vous utilisez l’app"),
             alert(@"Autoriser", YES, @"à accéder à vos données de localisation même lorsque vous n’utilisez pas l’app"),
             alert(@"Autoriser", YES, @"à accéder aussi à vos données de localisation lorsque vous n’utilisez pas l’app"),
             alert(@"OK", YES, @"souhaite accéder à vos contacts"),
             alert(@"OK", YES, @"souhaite accéder à votre calendrier"),
             alert(@"OK", YES, @"souhaite accéder à vos rappels"),
             alert(@"OK", YES, @"souhaite accéder à vos mouvements et vos activités physiques"),
             alert(@"OK", YES, @"souhaite accéder à vos photos"),
             alert(@"OK", YES, @"souhaite accéder à l’appareil photo"),
             alert(@"OK", YES, @"souhaite accéder aux comptes Twitter"),
             alert(@"OK", YES, @"souhaite accéder au micro"),
             alert(@"Ouvrir", YES, @"Ouvrir dans"),
             alert(@"OK", YES, @"Aucune carte SIM")
             ];
}

- (NSArray<SpringBoardAlert *> *)RussianAlerts {
    return @[
             // Location
             alert(@"OK", YES, @"запрашивает разрешение на использование Ващей текущей пгеопозиции"),
             alert(@"Открыть", YES, @"Открыть в программе")
             ];
}

- (NSArray<SpringBoardAlert *> *)PTBrazilAlerts {
    return @[
             alert(@"Permitir", YES, @"acesso à sua localização"),
             alert(@"Permitir", YES, @"acesso à sua localização"),
             alert(@"OK", YES, @"Deseja Ter Acesso às Suas Fotos"),
             alert(@"OK", YES, @"Deseja Ter Acesso aos Seus Contatos"),
             alert(@"OK", YES, @"Acesso ao Seu Calendário"),
             alert(@"OK", YES, @"Deseja Ter Acesso aos Seus Lembretes"),
             alert(@"OK", YES, @"Would Like to Access Your Motion Activity"),
             alert(@"OK", YES, @"Deseja Ter Acesso à Câmera"),
             alert(@"OK", YES, @"Deseja Ter Acesso às Suas Atividades de Movimento e Preparo Físico"),
             alert(@"OK", YES, @"Deseja Ter Acesso às Contas do Twitter"),
             alert(@"OK", YES, @"Deseja enviar-lhe notificações"),
             alert(@"Permitir", YES, @"Deseja Enviar Notificações"),
             alert(@"Abrir", YES, @"Abrir com")
             ];
}

- (NSArray<SpringBoardAlert *> *)KoreanAlerts {
    return @[
             alert(@"허용", YES, @"에서 사용자의 위치에 접근하도록 허용하겠습니까"),
             alert(@"허용", YES, @"을(를) 사용하지 않을 때에도 해당 앱이 사용자의 위치에 접근하도록 허용하곘습니까"),
             alert(@"승인", YES, @"이(가) 사용자의 연락처에 접근하려고 합니다"),
             alert(@"승인", YES, @"이(가) 사용자의 캘린더에 접근하려고 합니다"),
             alert(@"승인", YES, @"이(가) 사용자의 미리 알림에 접근하려고 합니다"),
             alert(@"승인", YES, @"이(가) 사용자의 사진에 접근하려고 합니다"),
             alert(@"승인", YES, @"이(가) 카메라에 접근하려고 합니다"),
             alert(@"승인", YES, @"에서 Twitter 계정에 접근하려고 합니다"),
             alert(@"승인", YES, @"이(가) 마이크에 접근하려고 합니다"),
             alert(@"승인", YES, @"이(가) 사용자의 동작 및 피트니스 활동에 접근하려고 합니다"),
             alert(@"허용", YES, @"에서 알림을 보내고자 합니다"),
             alert(@"열기", YES, @"에서 열겠습니까?")
             ];
}

@end

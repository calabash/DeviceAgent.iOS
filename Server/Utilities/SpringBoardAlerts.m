
#import "SpringBoardAlerts.h"
#import "SpringBoardAlert.h"


// Convenience method for creating alerts from the regular expressions found in run_loop
// scripts/lib/on_alert.js
static SpringBoardAlert *alert(NSArray *buttonTitles, BOOL shouldAccept, NSString *title) {
    return [[SpringBoardAlert alloc] initWithAlertTitleFragment:title
                                             dismissButtonTitles:buttonTitles
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
- (NSArray<SpringBoardAlert *> *)ItalianAlerts;
- (NSArray<SpringBoardAlert *> *)HebrewAlerts;
- (NSArray<SpringBoardAlert *> *)HungarianAlerts;
- (NSArray<SpringBoardAlert *> *)GreekAlerts;
- (NSArray<SpringBoardAlert *> *)CzechAlerts;

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
                                            [self KoreanAlerts],
                                            [self ItalianAlerts],
                                            [self HebrewAlerts],
                                            [self GreekAlerts],
                                            [self HungarianAlerts],
                                            [self CzechAlerts]
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
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Would Like to Use Your Current Location"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Location Accuracy"),
             alert([NSArray arrayWithObjects: @"Allow", nil], YES, @"access your location"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Health Access"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Would Like to Access Your Photos"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Would like to Add to your Photos"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Would Like to Access Your Contacts"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Access the Microphone"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Would Like to Access Your Calendar"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Would Like to Access Your Reminders"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Would Like to Access Your Motion Activity"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Would Like to Access the Camera"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Would Like to Access Your Motion & Fitness Activity"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Would Like Access to Twitter Accounts"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"data available to nearby bluetooth devices"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Would Like to Send You Push Notifications"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Would Like to Send You Notifications"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"No SIM Card Installed"),
             alert([NSArray arrayWithObjects: @"Not Now", nil], NO, @"Carrier Settings Update"),
             alert([NSArray arrayWithObjects: @"Not Now", nil], NO, @"Enable Dictation?"),
             alert([NSArray arrayWithObjects: @"Dismiss", nil], NO, @"iPhone is not Activated"),
             alert([NSArray arrayWithObjects: @"Cancel", nil], NO, @"Sign In to iTunes Store"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Would Like to Access Apple Music And Your Media Library"),
             alert([NSArray arrayWithObjects: @"Allow", nil], YES, @"Would Like to Add VPN Configurations"),
             alert([NSArray arrayWithObjects: @"Open", nil], YES, @"Open in"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"access Apple Music"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Access Speech Recognition")
             ];
}

- (NSArray<SpringBoardAlert *> *)DanishAlerts {
    return @[
             alert([NSArray arrayWithObjects: @"Tillad", nil], YES, @"bruge din lokalitet, når du bruger appen"),
             alert([NSArray arrayWithObjects: @"Tillad", nil], YES, @"også når du ikke bruger appen"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"vil bruge din aktuelle placering"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"vil bruge dine kontakter"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"vil bruge mikrofonen"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"vil bruge din kalender"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"vil bruge dine påmindelser"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"vil bruge dine fotos"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"ønsker adgang til Twitter-konti"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"vil bruge din fysiske aktivitet og din træningsaktivitet"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"vil bruge kameraet"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"vil gerne sende dig meddelelser"),
             alert([NSArray arrayWithObjects: @"Åbn", nil], YES, @"Åbn i"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"desuden Apple med at forbedre"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"vil bruge talegenkendelse")
             ];
}

- (NSArray<SpringBoardAlert *> *)DutchAlerts {
    return @[
             alert([NSArray arrayWithObjects: @"Sta toe", nil], YES, @"tot uw locatie toestaan terwijl u de app gebruikt"),
             alert([NSArray arrayWithObjects: @"Sta toe", nil], YES, @"toegang tot uw locatie toestaan terwijl u de app gebruikt"),
             alert([NSArray arrayWithObjects: @"Sta toe", nil], YES, @"ook toegang tot uw locatie toestaan, zelfs als u de app niet gebruikt"),
             alert([NSArray arrayWithObjects: @"Sta toe", nil], YES, @"toegang tot uw locatie toestaan, zelfs als u de app niet gebruikt"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"wil toegang tot uw contacten"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"wil toegang tot uw agenda"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"wil toegang tot uw herinneringen"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"wil toegang tot uw foto's"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"wil toegang tot Twitter-accounts"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"wil toegang tot de microfoon"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"wil toegang tot uw bewegings- en fitnessactiviteit"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"wil toegang tot de camera"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"wil u berichten sturen"),
             alert([NSArray arrayWithObjects: @"Negeer", nil], YES, @"is niet geactiveerd"),
             alert([NSArray arrayWithObjects: @"Open", nil], YES, @"Openen met"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"wil toegang tot spraakherkenning")
             ];
}

- (NSArray<SpringBoardAlert *> *)DutchAlerts_BE {
    return @[
             alert([NSArray arrayWithObjects: @"Sta toe", nil], YES, @"toegang tot je locatie toestaan terwijl je de app gebruikt"),
             alert([NSArray arrayWithObjects: @"Sta toe", nil], YES, @"toegang tot je locatie toestaan, zelfs als je de app niet gebruikt"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"wil toegang tot je contacten"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"wil toegang tot je agenda"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"wil toegang tot je herinneringen"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"wil toegang tot je foto's"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"wil toegang tot Twitter-accounts"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"wil toegang tot de microfoon"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"wil toegang tot je bewegings- en fitnessactiviteit"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"wil toegang tot de camera")
             ];
}

- (NSArray<SpringBoardAlert *> *)SwedishAlerts {
    return @[
             alert([NSArray arrayWithObjects: @"Tillåt", nil], YES, @"att se din platsinfo när du använder appen"),
             alert([NSArray arrayWithObjects: @"Tillåt", nil], YES, @"även ser din platsinfo när du inte använder appen"),
             alert([NSArray arrayWithObjects: @"Tillåt", nil], YES, @"att se din platsinfo även när du inte använder appen"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"begär åtkomst till dina kontakter"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"begär åtkomst till din kalender"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"begär åtkomst till dina påminnelser"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"begär åtkomst till dina bilder"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"vill komma åt dina Twitter-konton"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"begär åtkomst till mikrofonen"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"begär åtkomst till din rörelse- och träningsaktivitet"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"begär åtkomst till kameran"),
             alert([NSArray arrayWithObjects: @"Tillåt", nil], YES, @"vill skicka notiser till dig"),
             alert([NSArray arrayWithObjects: @"Öppna", nil], YES, @"Öppna i"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"begär åtkomst till röstigenkänning")
             ];
}
- (NSArray<SpringBoardAlert *> *)GermanAlerts {
    return @[
             alert([NSArray arrayWithObjects: @"Ja", nil], YES, @"Ihren aktuellen Ort verwenden"),
             alert([NSArray arrayWithObjects: @"Erlauben", nil], YES, @"auf Ihren Standort zugreifen, wenn Sie die App benutzen"),
             alert([NSArray arrayWithObjects: @"Erlauben", nil], YES, @"auch auf Ihren Standort zugreifen, wenn Sie die App nicht benutzen"),
             alert([NSArray arrayWithObjects: @"Erlauben", nil], YES, @"auf Ihren Standort zugreifen, selbst wenn Sie die App nicht benutzen"),
             alert([NSArray arrayWithObjects: @"Ja", nil], YES, @"auf Ihre Kontakte zugreifen"),
             alert([NSArray arrayWithObjects: @"Ja", nil], YES, @"auf Ihren Kalender zugreifen"),
             alert([NSArray arrayWithObjects: @"Ja", nil], YES, @"auf Ihre Erinnerungen zugreifen"),
             alert([NSArray arrayWithObjects: @"Ja", nil], YES, @"auf Ihre Fotos zugreifen"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"möchte auf deine Fotos zugreifen"),
             alert([NSArray arrayWithObjects: @"Erlauben", nil], YES, @"möchte auf Twitter-Accounts zugreifen"),
             alert([NSArray arrayWithObjects: @"Ja", nil], YES, @"auf das Mikrofon zugreifen"),
             alert([NSArray arrayWithObjects: @"Ja", nil], YES, @"möchte auf Ihre Bewegungs- und Fitnessdaten zugreifen"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"möchte auf deine Kamera zugreifen"),
             alert([NSArray arrayWithObjects: @"Ja", nil], YES, @"auf Ihre Kamera zugreifen"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Ihnen Mitteilungen senden"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"dir Mitteilungen senden"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Keine SIM-Karte eingelegt"),
             alert([NSArray arrayWithObjects: @"Öffnen", nil], YES, @"öffnen?"),
             alert([NSArray arrayWithObjects: @"Erlauben", nil], YES, @"auf deinen Standort zugreifen, wenn du die App verwendest"),
             alert([NSArray arrayWithObjects: @"Immer erlauben", nil], YES, @"auf deinen Standort zugreifen"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Spracherkennung zugreifen")
             ];
}

- (NSArray<SpringBoardAlert *> *)EUSpanishAlerts {
    return @[
             alert([NSArray arrayWithObjects: @"Permitir", nil], YES, @"acceder a tu ubicación mientras utilizas la aplicación"),
             alert([NSArray arrayWithObjects: @"Permitir", nil], YES, @"acceder a tu ubicación aunque no estés utilizando la aplicación"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"quiere acceder a tus contactos"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"quiere acceder a tu calendario"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"quiere acceder a tus recordatorios"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"quiere acceder a tus fotos"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"quiere obtener acceso a cuentas Twitter"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"quiere acceder al micrófono"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"desea acceder a tu actividad física y deportiva"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"quiere acceder a la cámara"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"quiere enviarte notificaciones"),
             alert([NSArray arrayWithObjects: @"Abrir", nil], YES, @"¿Abrir en"),
             alert([NSArray arrayWithObjects: @"Permitir", nil], YES, @"quiere acceder al reconocimiento de voz")
             ];
}

- (NSArray<SpringBoardAlert *> *)ES419SpanishAlerts {
    return @[
             alert([NSArray arrayWithObjects: @"Permitir", nil], YES, @"acceda a tu ubicación mientras la app está en uso"),
             alert([NSArray arrayWithObjects: @"Permitir", nil], YES, @"acceda a tu ubicación incluso cuando la app no está en uso"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"quiere acceder a tu condición y actividad física")
             ];
}

- (NSArray<SpringBoardAlert *> *)FrenchAlerts {
    return @[
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"vous envoyer des notifications"),
             alert([NSArray arrayWithObjects: @"Autoriser", nil], YES, @"à accéder à vos données de localisation lorsque vous utilisez l’app"),
             alert([NSArray arrayWithObjects: @"Toujours autoriser", nil], YES, @"à accéder à votre position"),
             alert([NSArray arrayWithObjects: @"Autoriser", nil], YES, @"à accéder à vos données de localisation même lorsque vous n’utilisez pas l’app"),
             alert([NSArray arrayWithObjects: @"Autoriser", nil], YES, @"à accéder aussi à vos données de localisation lorsque vous n’utilisez pas l’app"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"souhaite accéder à vos contacts"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"souhaite accéder à votre calendrier"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"souhaite accéder à vos rappels"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"souhaite accéder à vos mouvements et vos activités physiques"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"souhaite accéder à vos photos"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"souhaite accéder à l’appareil photo"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"souhaite accéder aux comptes Twitter"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"souhaite accéder au micro"),
             alert([NSArray arrayWithObjects: @"Ouvrir", nil], YES, @"Ouvrir dans"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Aucune carte SIM"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"souhaite accéder à la reconnaissance vocale")
             ];
}

- (NSArray<SpringBoardAlert *> *)RussianAlerts {
    return @[
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"запрашивает разрешение на использование Вашей текущей геопозиции"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"запрашивает разрешение на доступ к учетным записям Twitter"),
             alert([NSArray arrayWithObjects: @"Открыть", nil], YES, @"Открыть в программе"),
             alert([NSArray arrayWithObjects: @"Разрешить", nil], YES, @"запрашивает доступ к «Камере»."),
             alert([NSArray arrayWithObjects: @"Разрешить", nil], YES, @"запрашивает доступ к «Фото»."),
             alert([NSArray arrayWithObjects: @"Разрешить", nil], YES, @"запрашивает доступ к микрофону."),
             alert([NSArray arrayWithObjects: @"Разрешить", nil], YES, @"доступ к Вашим геоданным"),
             alert([NSArray arrayWithObjects: @"Разрешить", nil], YES, @"доступ к Вашей геопозиции, даже когда Вы не работаете с этой программой?"),
             alert([NSArray arrayWithObjects: @"Разрешить", nil], YES, @"доступ к Вашей геопозиции, пока Вы работаете с этой программой?"),
             alert([NSArray arrayWithObjects: @"Разрешить", nil], YES, @"запрашивает доступ к «Контактам»."),
             alert([NSArray arrayWithObjects: @"Разрешить", nil], YES, @"запрашивает доступ к «Напоминаниям»."),
             alert([NSArray arrayWithObjects: @"Разрешать всегда", nil], YES, @"доступ к Вашей геопозиции?"),
             alert([NSArray arrayWithObjects: @"Разрешить", nil], YES, @"запрашивает доступ к «Календарю»."),
             alert([NSArray arrayWithObjects: @"Разрешить", nil], YES, @"запрашивает доступ к Вашим данным движения и фитнеса"),
             alert([NSArray arrayWithObjects: @"Разрешить", nil], YES, @"запрашивает разрешение на отправку Вам уведомлений."),
             alert([NSArray arrayWithObjects: @"Разрешить", nil], YES, @"доступ к Apple Music"),
             alert([NSArray arrayWithObjects: @"Разрешить", nil], YES, @"запрашивает доступ к «Распознаванию речи»")
             ];
}

- (NSArray<SpringBoardAlert *> *)PTBrazilAlerts {
    return @[
             alert([NSArray arrayWithObjects: @"Permitir", nil], YES, @"acesso à sua localização"),
             alert([NSArray arrayWithObjects: @"Permitir", nil], YES, @"acesso à sua localização"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Deseja Ter Acesso às Suas Fotos"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Deseja Ter Acesso aos Seus Contatos"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Acesso ao Seu Calendário"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Deseja Ter Acesso aos Seus Lembretes"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Would Like to Access Your Motion Activity"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Deseja Ter Acesso à Câmera"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Deseja Ter Acesso às Suas Atividades de Movimento e Preparo Físico"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Deseja Ter Acesso às Contas do Twitter"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Deseja enviar-lhe notificações"),
             alert([NSArray arrayWithObjects: @"Permitir", nil], YES, @"Deseja Enviar Notificações"),
             alert([NSArray arrayWithObjects: @"Abrir", nil], YES, @"Abrir com"),
             alert([NSArray arrayWithObjects: @"OK", nil], YES, @"Deseja Ter Acesso ao Reconhecimento de Voz")
             ];
}

- (NSArray<SpringBoardAlert *> *)KoreanAlerts {
  return @[
      alert([NSArray arrayWithObjects: @"허용", nil], YES, @"에서 사용자의 위치에 접근하도록 허용하겠습니까"),
      alert([NSArray arrayWithObjects: @"허용", nil], YES, @"을(를) 사용하지 않을 때에도 해당 앱이 사용자의 위치에 접근하도록 허용하곘습니까"),
      alert([NSArray arrayWithObjects: @"허용", nil], YES, @"을(를) 사용하는 동안 해당 앱이 사용자의 위치에 접근하도록 허용하겠습니까"),
      alert([NSArray arrayWithObjects: @"승인", nil], YES, @"이(가) 사용자의 연락처에 접근하려고 합니다"),
      alert([NSArray arrayWithObjects: @"승인", nil], YES, @"이(가) 사용자의 캘린더에 접근하려고 합니다"),
      alert([NSArray arrayWithObjects: @"승인", nil], YES, @"이(가) 사용자의 미리 알림에 접근하려고 합니다"),
      alert([NSArray arrayWithObjects: @"승인", nil], YES, @"이(가) 사용자의 사진에 접근하려고 합니다"),
      alert([NSArray arrayWithObjects: @"승인", nil], YES, @"이(가) 카메라에 접근하려고 합니다"),
      alert([NSArray arrayWithObjects: @"승인", nil], YES, @"에서 Twitter 계정에 접근하려고 합니다"),
      alert([NSArray arrayWithObjects: @"승인", nil], YES, @"이(가) 마이크에 접근하려고 합니다"),
      alert([NSArray arrayWithObjects: @"승인", nil], YES, @"이(가) 사용자의 동작 및 피트니스 활동에 접근하려고 합니다"),
      alert([NSArray arrayWithObjects: @"허용", nil], YES, @"에서 알림을 보내고자 합니다"),
      alert([NSArray arrayWithObjects: @"열기", nil], YES, @"에서 열겠습니까?"),
      alert([NSArray arrayWithObjects: @"승인", nil], YES, @"이(가) 음성 인식에 접근하려고 합니다")
  ];
}

- (NSArray<SpringBoardAlert *> *)ItalianAlerts {
  return @[
    alert([NSArray arrayWithObjects: @"Consenti sempre", nil], YES, @"di accedere alla tua posizione"),
    alert([NSArray arrayWithObjects: @"Consenti", nil], YES, @"di accedere ai dati relativi alla tua posizione quando stai usando l'app"),
    alert([NSArray arrayWithObjects: @"Consenti", nil], YES, @"di accedere ai dati relativi alla tua posizione mentre utilizzi l'app"),
    alert([NSArray arrayWithObjects: @"Consenti", nil], YES, @"di accedere anche ai dati relativi alla tua posizione quando l'app non è in uso"),
    alert([NSArray arrayWithObjects: @"OK", nil], YES, @"vorrebbe accedere alla fotocamera"),
    alert([NSArray arrayWithObjects: @"OK", nil], YES, @"vorrebbe accedere al microfono"),
    alert([NSArray arrayWithObjects: @"OK", nil], YES, @"vorrebbe accedere alle tue Foto"),
    alert([NSArray arrayWithObjects: @"OK", nil], YES, @"vorrebbe accedere ai tuoi Contatti"),
    alert([NSArray arrayWithObjects: @"OK", nil], YES, @"vorrebbe accedere al tuo Calendario"),
    alert([NSArray arrayWithObjects: @"OK", nil], YES, @"vorrebbe accedere ai tuoi Promemoria"),
    alert([NSArray arrayWithObjects: @"OK", nil], YES, @"vorrebbe rendere disponibili i dati ai dispositivi Bluetooth nelle vicinanze anche quando non è in uso"),
    alert([NSArray arrayWithObjects: @"OK", nil], YES, @"vorrebbe inviarti delle notifiche"),
    alert([NSArray arrayWithObjects: @"OK", nil], YES, @"vorrebbe inviarti notifiche"),
    alert([NSArray arrayWithObjects: @"OK", nil], YES, @"desodera accedere all'opzione di riconoscimento vocale"),
    alert([NSArray arrayWithObjects: @"OK", nil], YES, @"desidera accedere ai dati di “Movimento e fitness”"),
    alert([NSArray arrayWithObjects: @"OK", nil], YES, @"vorrebbe accedere agli account Twitter"),
    alert([NSArray arrayWithObjects: @"OK", nil], YES, @"desidera accedere all'opzione di riconoscimento vocale")
  ];
}

- (NSArray<SpringBoardAlert *> *)HebrewAlerts {
  return @[
    alert([NSArray arrayWithObjects: @"אפשר", nil], YES, @"ת לפרטי מיקומך בעת שימושך בייש"),
    alert([NSArray arrayWithObjects: @"אפשר", nil], YES, @"לפרטי מיקומך גם כשאינך משתמש/ת בייש"),
    alert([NSArray arrayWithObjects: @"אפשר", nil], YES, @"ת לפרטי מיקומך אפילו כשאינך משתמש/ת בייש"),
    alert([NSArray arrayWithObjects: @"אפשר", nil], YES, @"לגשת לפרטי מיקומך גם כשאינך משתמש/ת בייש"),
    alert([NSArray arrayWithObjects: @"אפשר", nil], YES, @"קש לגשת לאנשי הקשר ש"),
    alert([NSArray arrayWithObjects: @"אפשר", nil], YES, @"וניין לגשת ללוח השנה ש"),
    alert([NSArray arrayWithObjects: @"אפשר", nil], YES, @"וניין לגשת למשימות ש"),
    alert([NSArray arrayWithObjects: @"אפשר", nil], YES, @"וניין לגשת לתמונות ש"),
    alert([NSArray arrayWithObjects: @"אפשר", nil], YES, @"וניין לגשת אל פעילות התנועה והכושר ש"),
    alert([NSArray arrayWithObjects: @"אפשר", nil], YES, @"מבקש להשתמש במצל"),
    alert([NSArray arrayWithObjects: @"אפשר", nil], YES, @"מבקש לגשת לחשבונ"),
    alert([NSArray arrayWithObjects: @"אפשר", nil], YES, @"מעוניין לאפשר להתקני Bluetooth קרובים לקבל גישה לנתונים אפילו כשאינך משתמש/ת ביישום"),
    alert([NSArray arrayWithObjects: @"אפשר", nil], YES, @"מעוניין לשלוח לך עדכונים"),
    alert([NSArray arrayWithObjects: @"אפשר", nil], YES, @"מעוניין לגשת אל זיהוי הדיבור ש")
  ];
}

- (NSArray<SpringBoardAlert *> *)GreekAlerts {
  return @[
    alert([NSArray arrayWithObjects: @"Να επιτρέπεται", nil], YES, @"η πρόσβαση στην τοποθεσία σας"),
    alert([NSArray arrayWithObjects: @"Ναι", nil], YES, @"για να σας στέλνει γνωστοποιήσεις")
  ];
}

- (NSArray<SpringBoardAlert *> *)HungarianAlerts {
  return @[
    alert([NSArray arrayWithObjects: @"Engedélyezés", nil], YES, @"hozzáférjen az Ön helyzetéhez az alkalmazás használatakor"),
    alert([NSArray arrayWithObjects: @"Engedélyezés", nil], YES, @"értesítéseket szeretne Önnek küldeni"),
    alert([NSArray arrayWithObjects: @"Engedélyezés mindig", nil], YES, @"számára, hogy hozzáférjen az Ön helyzetéhez")
  ];
}

- (NSArray<SpringBoardAlert *> *)CzechAlerts {
  return @[
    alert([NSArray arrayWithObjects: @"Povolit", nil], YES, @"povolit přístup k polohovým údajům v čase, kdy ji používáte"),
	alert([NSArray arrayWithObjects: @"Povolit vždy", nil], YES, @"využívat vaše polohové údaje"),
	alert([NSArray arrayWithObjects: @"Povolit", nil], YES, @"vám chce zasílat oznámení")
  ];
}
@end

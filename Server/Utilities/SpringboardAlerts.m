
#import "SpringboardAlerts.h"
#import "SpringboardAlert.h"

@interface SpringboardAlerts ()

@property(strong) NSArray<SpringboardAlert *> *alerts;

- (instancetype)init_private;
- (NSArray<SpringboardAlert *> *)concatenateArrays:(NSArray<NSArray *> *)arrays;
- (NSArray<SpringboardAlert *> *)alertsFromButtonTitleAndTitleArray:(NSArray<NSArray *> *)array;
- (NSArray<SpringboardAlert *> *)USEnglishAlerts;
- (NSArray<SpringboardAlert *> *)DanishAlerts;
- (NSArray<SpringboardAlert *> *)DutchAlerts;
- (NSArray<SpringboardAlert *> *)GermanAlerts;
- (NSArray<SpringboardAlert *> *)EUSpanishAlerts;
- (NSArray<SpringboardAlert *> *)ES419SpanishAlerts;
- (NSArray<SpringboardAlert *> *)FrenchAlerts;
- (NSArray<SpringboardAlert *> *)RussianAlerts;

@end

@implementation SpringboardAlerts

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Cannot call init"
                                   reason:@"This is a singleton class"
                                 userInfo:nil];
}

- (instancetype)init_private {
    self = [super init];
    if (self) {
        // Approximate count of existing regular expressions from UIA
        _alerts = [self concatenateArrays:@[
                                            [self USEnglishAlerts],
                                            [self DanishAlerts],
                                            [self DutchAlerts],
                                            [self EUSpanishAlerts],
                                            [self ES419SpanishAlerts],
                                            [self GermanAlerts],
                                            [self FrenchAlerts],
                                            [self RussianAlerts]
                                            ]];
    }
    return self;
}

+ (SpringboardAlerts *)shared {
    static SpringboardAlerts *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[SpringboardAlerts alloc] init_private];
    });
    return shared;
}


- (SpringboardAlert *)springboardAlertForAlertTitle:(NSString *)alertTitle {

    __block SpringboardAlert *match = nil;
    [self.alerts enumerateObjectsUsingBlock:^(SpringboardAlert *alert, NSUInteger idx, BOOL *stop) {
        if ([alert matchesAlertTitle:alertTitle]) {
            match = alert;
            *stop = YES;
        }
    }];

    return match;
}

- (NSArray<SpringboardAlert *> *)concatenateArrays:(NSArray<NSArray *> *)arrays {
    __block NSArray *final = @[];
    [arrays enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger idx, BOOL *stop) {
        final = [final arrayByAddingObjectsFromArray:array];
    }];
    return final;
}

- (NSArray<SpringboardAlert *> *)alertsFromButtonTitleAndTitleArray:(NSArray<NSArray *> *)array {
    NSMutableArray<SpringboardAlert *> *alerts = [NSMutableArray arrayWithCapacity:array.count];

    __block NSString *buttonTitle, *title;
    __block BOOL shouldAccept;
    [array enumerateObjectsUsingBlock:^(NSArray *tokens, NSUInteger idx, BOOL *stop) {
        buttonTitle = tokens[0];
        shouldAccept = [tokens[1] boolValue];
        title = tokens[2];
        [alerts addObject:[[SpringboardAlert alloc] initWithAlertTitleFragment:title
                                                           dismissButtonTitle:buttonTitle
                                                                 shouldAccept:shouldAccept]];
    }];
    return [NSArray arrayWithArray:alerts];
}

- (NSArray<SpringboardAlert *> *)USEnglishAlerts {
    NSArray *array = @[
                       @[@"OK", @YES, @"Would Like to Use Your Current Location"],
                       @[@"OK", @YES, @"Location Accuracy"],
                       @[@"Allow", @YES, @"access your location"],
                       @[@"OK", @YES, @"Would Like to Access Your Photos"],
                       @[@"OK", @YES, @"Would Like to Access Your Contacts"],
                       @[@"OK", @YES, @"Access the Microphone"],
                       @[@"OK", @YES, @"Would Like to Access Your Calendar"],
                       @[@"OK", @YES, @"Would Like to Access Your Reminders"],
                       @[@"OK", @YES, @"Would Like to Access Your Motion Activity"],
                       @[@"OK", @YES, @"Would Like to Access the Camera"],
                       @[@"OK", @YES, @"Would Like to Access Your Motion & Fitness Activity"],
                       @[@"OK", @YES, @"Would Like Access to Twitter Accounts"],
                       @[@"OK", @YES, @"data available to nearby bluetooth devices"],
                       @[@"OK", @YES, @"Would Like to Send You Push Notifications"],
                       @[@"OK", @YES, @"would like to send you Push Notifications"],
                       @[@"OK", @YES, @"Would Like to Send You Notifications"],
                       @[@"OK", @YES, @"would like to send you Notifications"],
                       @[@"OK", @YES, @"No SIM Card Installed"],
                       @[@"Not Now", @NO, @"Carrier Settings Update"]
                       ];
    return [self alertsFromButtonTitleAndTitleArray:array];
}

- (NSArray<SpringboardAlert *> *)DanishAlerts {
    NSArray *array = @[
                       @[@"Tillad", @YES, @"bruge din lokalitet, når du bruger appen"],
                       @[@"Tillad", @YES, @"også når du ikke bruger appen"],
                       @[@"OK", @YES, @"vil bruge din aktuelle placering"],
                       @[@"OK", @YES, @"vil bruge dine kontakter"],
                       @[@"OK", @YES, @"vil bruge mikrofonen"],
                       @[@"OK", @YES, @"vil bruge din kalender"],
                       @[@"OK", @YES, @"vil bruge dine påmindelser"],
                       @[@"OK", @YES, @"vil bruge dine fotos"],
                       @[@"OK", @YES, @"ønsker adgang til Twitter-konti"],
                       @[@"OK", @YES, @"vil bruge din fysiske aktivitet og din træningsaktivitet"],
                       @[@"OK", @YES, @"vil bruge kameraet"],
                       @[@"OK", @YES, @"vil gerne sende dig meddelelser"]
                       ];
    return [self alertsFromButtonTitleAndTitleArray:array];
}

- (NSArray<SpringboardAlert *> *)DutchAlerts {
    NSArray *array = @[
                       @[@"Sta toe", @YES, @"tot uw locatie toestaan terwijl u de app gebruikt"],
                       @[@"Sta toe", @YES, @"toegang tot uw locatie toestaan terwijl u de app gebruikt"],
                       @[@"Sta toe", @YES, @"ook toegang tot uw locatie toestaan, zelfs als u de app niet gebruikt"],
                       @[@"Sta toe", @YES, @"toegang tot uw locatie toestaan, zelfs als u de app niet gebruikt"],
                       @[@"OK", @YES, @"wil toegang tot uw contacten"],
                       @[@"OK", @YES, @"wil toegang tot uw agenda"],
                       @[@"OK", @YES, @"wil toegang tot uw herinneringen"],
                       @[@"OK", @YES, @"wil toegang tot uw foto's"],
                       @[@"OK", @YES, @"wil toegang tot Twitter-accounts"],
                       @[@"OK", @YES, @"wil toegang tot de microfoon"],
                       @[@"OK", @YES, @"wil toegang tot uw bewegings- en fitnessactiviteit"],
                       @[@"OK", @YES, @"wil toegang tot de camera"],
                       @[@"OK", @YES, @"wil u berichten sturen"]
                       ];
    return [self alertsFromButtonTitleAndTitleArray:array];
}

- (NSArray<SpringboardAlert *> *)GermanAlerts {
    NSArray *array = @[
                       @[@"Ja", @YES, @"Ihren aktuellen Ort verwenden"],
                       @[@"Erlauben", @YES, @"auf Ihren Standort zugreifen, wenn Sie die App benutzen"],
                       @[@"Erlauben", @YES, @"auch auf Ihren Standort zugreifen, wenn Sie die App nicht benutzen"],
                       @[@"Erlauben", @YES, @"auf Ihren Standort zugreifen, selbst wenn Sie die App nicht benutzen"],
                       @[@"Ja", @YES, @"auf Ihre Kontakte zugreifen"],
                       @[@"Ja", @YES, @"auf Ihren Kalender zugreifen"],
                       @[@"Ja", @YES, @"auf Ihre Erinnerungen zugreifen"],
                       @[@"Ja", @YES, @"auf Ihre Fotos zugreifen"],
                       @[@"Erlauben", @YES, @"möchte auf Twitter-Accounts zugreifen"],
                       @[@"Ja", @YES, @"auf das Mikrofon zugreifen"],
                       @[@"Ja", @YES, @"möchte auf Ihre Bewegungs- und Fitnessdaten zugreifen"],
                       @[@"Ja", @YES, @"auf Ihre Kamera zugreifen"],
                       @[@"OK", @YES, @"Ihnen Mitteilungen senden"],
                       @[@"OK", @YES, @"Keine SIM-Karte eingelegt"]
                       ];
    return [self alertsFromButtonTitleAndTitleArray:array];
}

- (NSArray<SpringboardAlert *> *)EUSpanishAlerts {
    NSArray *array = @[
                       @[@"Permitir", @YES, @"acceder a tu ubicación mientras utilizas la aplicación"],
                       @[@"Permitir", @YES, @"acceder a tu ubicación aunque no estés utilizando la aplicación"],
                       @[@"OK", @YES, @"quiere acceder a tus contactos"],
                       @[@"OK", @YES, @"quiere acceder a tu calendario"],
                       @[@"OK", @YES, @"quiere acceder a tus recordatorios"],
                       @[@"OK", @YES, @"quiere acceder a tus fotos"],
                       @[@"OK", @YES, @"quiere obtener acceso a cuentas Twitter"],
                       @[@"OK", @YES, @"quiere acceder al micrófono"],
                       @[@"OK", @YES, @"desea acceder a tu actividad física y deportiva"],
                       @[@"OK", @YES, @"quiere acceder a la cámara"],
                       @[@"OK", @YES, @"quiere enviarte notificaciones"]
                       ];
    return [self alertsFromButtonTitleAndTitleArray:array];
}

- (NSArray<SpringboardAlert *> *)ES419SpanishAlerts {
    NSArray *array = @[
                       @[@"Permitir", @YES, @"acceda a tu ubicación mientras la app está en uso"],
                       @[@"Permitir", @YES, @"acceda a tu ubicación incluso cuando la app no está en uso"],
                       @[@"OK", @YES, @"quiere acceder a tu condición y actividad física"]
                       ];
    return [self alertsFromButtonTitleAndTitleArray:array];
}
- (NSArray<SpringboardAlert *> *)FrenchAlerts {
    NSArray *array = @[
                       @[@"OK", @YES, @"vous envoyer des notifications"],
                       @[@"Autoriser", @YES, @"à accéder à vos données de localisation lorsque vous utilisez l’app"],
                       @[@"Autoriser", @YES, @"à accéder à vos données de localisation même lorsque vous n’utilisez pas l’app"],
                       @[@"Autoriser", @YES, @"à accéder aussi à vos données de localisation lorsque vous n’utilisez pas l’app"],
                       @[@"OK", @YES, @"souhaite accéder à vos contacts"],
                       @[@"OK", @YES, @"souhaite accéder à votre calendrier"],
                       @[@"OK", @YES, @"souhaite accéder à vos rappels"],
                       @[@"OK", @YES, @"souhaite accéder à vos mouvements et vos activités physiques"],
                       @[@"OK", @YES, @"souhaite accéder à vos photos"],
                       @[@"OK", @YES, @"souhaite accéder à l’appareil photo"],
                       @[@"OK", @YES, @"souhaite accéder aux comptes Twitter"],
                       @[@"OK", @YES, @"souhaite accéder au micro"]
                       ];
    return [self alertsFromButtonTitleAndTitleArray:array];
}

- (NSArray<SpringboardAlert *> *)RussianAlerts {
    NSArray *array = @[
                       // Location
                       @[@"OK", @YES, @"запрашивает разрешение на использование Ващей текущей пгеопозиции"]
                       ];
    return [self alertsFromButtonTitleAndTitleArray:array];
}

@end

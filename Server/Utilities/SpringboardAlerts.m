
#import "SpringboardAlerts.h"
#import "SpringboardAlert.h"


// Convenience method for creating alerts from the regexes found in run_loop
// scripts/lib/on_alert.js
static SpringboardAlert *alert(NSString *buttonTitle, BOOL shouldAccept, NSString *title) {
    return [[SpringboardAlert alloc] initWithAlertTitleFragment:title
                                             dismissButtonTitle:buttonTitle
                                                   shouldAccept:shouldAccept];
}

@interface SpringboardAlerts ()

@property(strong) NSArray<SpringboardAlert *> *alerts;

- (instancetype)init_private;
- (NSArray<SpringboardAlert *> *)concatenateArrays:(NSArray<NSArray *> *)arrays;
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

- (NSArray<SpringboardAlert *> *)USEnglishAlerts {
    return @[
             alert(@"OK", YES, @"Would Like to Use Your Current Location"),
             alert(@"OK", YES, @"Location Accuracy"),
             alert(@"Allow", YES, @"access your location"),
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
             alert(@"OK", YES, @"would like to send you Push Notifications"),
             alert(@"OK", YES, @"Would Like to Send You Notifications"),
             alert(@"OK", YES, @"would like to send you Notifications"),
             alert(@"OK", YES, @"No SIM Card Installed"),
             alert(@"Not Now", NO, @"Carrier Settings Update")
             ];
}

- (NSArray<SpringboardAlert *> *)DanishAlerts {
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
             alert(@"OK", YES, @"vil gerne sende dig meddelelser")
             ];
}

- (NSArray<SpringboardAlert *> *)DutchAlerts {
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
             alert(@"OK", YES, @"wil u berichten sturen")
             ];
}

- (NSArray<SpringboardAlert *> *)GermanAlerts {
    return @[
             alert(@"Ja", YES, @"Ihren aktuellen Ort verwenden"),
             alert(@"Erlauben", YES, @"auf Ihren Standort zugreifen, wenn Sie die App benutzen"),
             alert(@"Erlauben", YES, @"auch auf Ihren Standort zugreifen, wenn Sie die App nicht benutzen"),
             alert(@"Erlauben", YES, @"auf Ihren Standort zugreifen, selbst wenn Sie die App nicht benutzen"),
             alert(@"Ja", YES, @"auf Ihre Kontakte zugreifen"),
             alert(@"Ja", YES, @"auf Ihren Kalender zugreifen"),
             alert(@"Ja", YES, @"auf Ihre Erinnerungen zugreifen"),
             alert(@"Ja", YES, @"auf Ihre Fotos zugreifen"),
             alert(@"Erlauben", YES, @"möchte auf Twitter-Accounts zugreifen"),
             alert(@"Ja", YES, @"auf das Mikrofon zugreifen"),
             alert(@"Ja", YES, @"möchte auf Ihre Bewegungs- und Fitnessdaten zugreifen"),
             alert(@"Ja", YES, @"auf Ihre Kamera zugreifen"),
             alert(@"OK", YES, @"Ihnen Mitteilungen senden"),
             alert(@"OK", YES, @"Keine SIM-Karte eingelegt")
             ];
}

- (NSArray<SpringboardAlert *> *)EUSpanishAlerts {
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
             alert(@"OK", YES, @"quiere enviarte notificaciones")
             ];
}

- (NSArray<SpringboardAlert *> *)ES419SpanishAlerts {
    return @[
             alert(@"Permitir", YES, @"acceda a tu ubicación mientras la app está en uso"),
             alert(@"Permitir", YES, @"acceda a tu ubicación incluso cuando la app no está en uso"),
             alert(@"OK", YES, @"quiere acceder a tu condición y actividad física")
             ];
}

- (NSArray<SpringboardAlert *> *)FrenchAlerts {
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
             alert(@"OK", YES, @"souhaite accéder au micro")
             ];
}

- (NSArray<SpringboardAlert *> *)RussianAlerts {
    return @[
             // Location
             alert(@"OK", YES, @"запрашивает разрешение на использование Ващей текущей пгеопозиции")
             ];
}

@end

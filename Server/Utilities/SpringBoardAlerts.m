
#import <UIKit/UIKit.h>

#import "SpringBoardAlerts.h"
#import "SpringBoardAlert.h"

NSString * languages[] = {
    @"springboard-alerts-cs",
    @"springboard-alerts-da",
    @"springboard-alerts-de",
    @"springboard-alerts-el",
    @"springboard-alerts-en",
    @"springboard-alerts-es_419",
    @"springboard-alerts-fr",
    @"springboard-alerts-he",
    @"springboard-alerts-hu",
    @"springboard-alerts-it",
    @"springboard-alerts-ko",
    @"springboard-alerts-nl",
    @"springboard-alerts-pt_PT",
    @"springboard-alerts-ru",
    @"springboard-alerts-sv"};

int LANGUAGES_COUNT = sizeof(languages)/sizeof(languages[0]);

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
        NSBundle * bundle = [NSBundle bundleForClass:[self class]];
        NSMutableArray<SpringBoardAlert *> * result =
        [NSMutableArray<SpringBoardAlert *> array];
        
        for (int languagei = 0; languagei < LANGUAGES_COUNT; languagei++) {
            NSString * language = languages[languagei];
            NSDataAsset *asset = [[NSDataAsset alloc]
                                  initWithName:language
                                  bundle:bundle];
            
            NSArray * alerts = [NSJSONSerialization
                                JSONObjectWithData:[asset data]
                                options:kNilOptions
                                error:nil];
            for (int i=0; i < alerts.count; i++) {
                NSDictionary* alertDict = alerts[i];
                NSString * title = [alertDict objectForKey:@"title"];
                NSArray * buttons = [alertDict objectForKey:@"buttons"];
                id shouldAccept = [alertDict objectForKey: @"shouldAccept"];
                if (title == nil) {
                    @throw [NSException
                            exceptionWithName:@"Bad springboard-alerts JSON"
                            reason: @"No title"
                            userInfo:@{@"language":language,
                                       @"alert":[NSNumber numberWithInt:i]}];
                }
                if (buttons == nil) {
                    @throw [NSException
                            exceptionWithName:@"Bad springboard-alerts JSON"
                            reason: @"No buttons"
                            userInfo:@{@"language":language,
                                       @"alert":[NSNumber numberWithInt:i]}];
                }
                if (buttons.count == 0) {
                    @throw [NSException
                            exceptionWithName:@"Bad springboard-alerts JSON"
                            reason: @"Zero size buttons array"
                            userInfo:@{@"language":language,
                                       @"alert":[NSNumber numberWithInt:i]}];
                }
                if (shouldAccept == nil) {
                    @throw [NSException
                            exceptionWithName:@"Bad springboard-alerts JSON"
                            reason: @"No shouldAccept"
                            userInfo:@{@"language":language,
                                       @"alert":[NSNumber numberWithInt:i]}];
                }
                [result
                 addObject: alert(buttons[0], [shouldAccept boolValue], title)];
            }
        }
        _alerts =  [NSArray<SpringBoardAlert *> arrayWithArray: result];
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


@end

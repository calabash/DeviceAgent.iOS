
#import <UIKit/UIKit.h>

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
    NSDataAsset *asset = [[NSDataAsset alloc] initWithName:@"alerts"];
    NSDictionary * languages = [NSJSONSerialization JSONObjectWithData:[asset data] options:kNilOptions error:nil];

    NSMutableArray<SpringBoardAlert *> * result = [NSMutableArray<SpringBoardAlert *> array];
    NSEnumerator * languagesEnumerator = [languages keyEnumerator];
    id language;
    
    while ((language = [languagesEnumerator nextObject])) {
        NSArray * alerts = [languages objectForKey: language];
        for (int i=0; i < alerts.count; i++) {
            NSDictionary* alertDict = alerts[i];
            NSString * title = [alertDict objectForKey:@"title"];
            NSArray * buttons = [alertDict objectForKey:@"buttons"];
            id shouldAccept = [alertDict objectForKey: @"shouldAccept"];
            if (title != nil && shouldAccept != nil && buttons != nil && buttons.count > 0 ){
                [result addObject: alert(buttons[0], shouldAccept, title)];
            }
        }
    }
    return [NSArray<SpringBoardAlert *> arrayWithArray: result];
}

@end

#import <UIKit/UIKit.h>

#import "CBXConstants.h"
#import "CBXMachClock.h"
#import "SpringBoardAlerts.h"
#import "SpringBoardAlert.h"

@interface CUICommonAssetStorage : NSObject

-(NSArray *)allAssetKeys;
-(NSArray *)allRenditionNames;

-(id)initWithPath:(NSString *)p;

-(NSString *)versionString;

@end

// Convenience method for creating alerts from the regular expressions found in run_loop
// scripts/lib/on_alert.js
static SpringBoardAlert *alert(NSArray *buttonTitles, BOOL shouldAccept, NSString *title) {
    return [[SpringBoardAlert alloc] initWithAlertTitleFragment:title
                                             dismissButtonTitles:buttonTitles
                                                   shouldAccept:shouldAccept];
}

@interface SpringBoardAlerts ()

@property(strong) NSArray<SpringBoardAlert *> *alerts;
+ (void)raiseIfInvalidAlert:(NSDictionary *)alertDict
                 ofLanguage:(NSString*)language
                andPosition:(NSInteger)position;
- (instancetype)init_private;
@end

@implementation SpringBoardAlerts

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Cannot call init"
                                   reason:@"This is a singleton class"
                                 userInfo:nil];
}

+ (void)raiseIfInvalidAlert:(NSDictionary *)alertDict
                 ofLanguage:(NSString*)language
                andPosition:(NSInteger)position {
    if (!alertDict[@"title"]) {
        @throw [NSException
                exceptionWithName:@"Bad springboard-alerts JSON"
                reason: @"No title"
                userInfo:@{@"language":language,
                           @"alert": alertDict,
                           @"position":@(position)}];
    }
    if (!alertDict[@"buttons"]) {
        @throw [NSException
                exceptionWithName:@"Bad springboard-alerts JSON"
                reason: @"No buttons"
                userInfo:@{@"language":language,
                           @"alert": alertDict,
                           @"position":@(position)}];
    }
    if (((NSArray *)alertDict[@"buttons"]).count == 0) {
        @throw [NSException
                exceptionWithName:@"Bad springboard-alerts JSON"
                reason: @"Zero size buttons array"
                userInfo:@{@"language":language,
                           @"alert": alertDict,
                           @"position":@(position)}];
    }
    if (!alertDict[@"shouldAccept"]) {
        @throw [NSException
                exceptionWithName:@"Bad springboard-alerts JSON"
                reason: @"No shouldAccept"
                userInfo:@{@"language":language,
                           @"alert": alertDict,
                           @"position":@(position)}];
    }
}

// [NSLocale preferredLanguages] returns language in format 'country-region' (like 'pt-PT')
// some particular frameworks / apps might not contain localization for particular language
// in this case the following chain will be used: 'pt_PT' -> 'pt' -> 'en'
// so we need to import languages via the same chain
- (instancetype)init_private {
    self = [super init];
    if (self) {
        NSTimeInterval startTime = [[CBXMachClock sharedClock] absoluteTime];

        NSMutableArray<SpringBoardAlert *> *resultArray =
        [NSMutableArray<SpringBoardAlert *> array];

        NSString * preferredLanguage = [[NSLocale preferredLanguages] firstObject];
        
        if ([preferredLanguage containsString:@"-"]) {
            // fix mismatching language name for Norwegian and Chinese languages
            NSString *validPreferredLanguage = [self fixLanguageName:preferredLanguage];
            // '.lproj' files uses '_' as separator. 'preferredLanguages' uses '-' as separator, need to convert
            NSString *fullLanguageName = [validPreferredLanguage stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
            // load exact name like "pt_PT"
            [self loadLanguageIfExists:fullLanguageName:resultArray];
            // load short name like "pt"
            NSString *shortLanguageName = [validPreferredLanguage componentsSeparatedByString:@"-"][0];
            [self loadLanguageIfExists:shortLanguageName:resultArray];
        } else {
            // if preferredLanguage is short name, just load it
            [self loadLanguageIfExists:preferredLanguage:resultArray];
        }

        // load "en" lang
        if (![preferredLanguage hasPrefix:@"en"]) {
            [self loadLanguageIfExists:@"en": resultArray];
        }

        _alerts =  [NSArray<SpringBoardAlert *> arrayWithArray: resultArray];
        NSTimeInterval elapsedSeconds =
        [[CBXMachClock sharedClock] absoluteTime] - startTime;
        DDLogDebug(@"SpringBoardAlerts.init_private took %@ seconds",
                   @(elapsedSeconds));
    }
    return self;
}

// Some language names can be different in different Xcode versions
// function maps language names to make sure that all xcode versions will work
- (NSString *)fixLanguageName:(NSString *)languageName {
    if ([languageName isEqualToString: @"zh-Hans-US"]) {
        return @"zh-CN";
    } else if ([languageName isEqualToString: @"zh-Hant-US"]) {
        return @"zh-TW";
    } else if ([languageName isEqualToString: @"zh-Hant-HK"]) {
        return @"zh-HK";
    } else if ([languageName isEqualToString: @"nb-US"]) {
        return @"no-US";
    } else {
        return languageName;
    }
}

- (void)loadLanguageIfExists:(NSString *)languageName
                            :(NSMutableArray<SpringBoardAlert *> *) resultArray {
    NSString * languagePath = [NSString stringWithFormat:@"springboard-alerts-%@", languageName];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSDataAsset *asset = [[NSDataAsset alloc]
                          initWithName:languagePath
                          bundle:bundle];
                               

   if (asset == nil) {
       // language is not found
       return;
   }

    NSArray *alerts = [NSJSONSerialization
                       JSONObjectWithData:[asset data]
                       options:kNilOptions
                       error:nil];

    for (NSUInteger i = 0; i < alerts.count; i++) {
        NSDictionary* alertDict = alerts[i];
        [SpringBoardAlerts raiseIfInvalidAlert:alertDict
                                    ofLanguage:languageName
                                   andPosition:i];
        [resultArray
         addObject: alert(
                          alertDict[@"buttons"][0],
                          [alertDict[@"shouldAccept"] boolValue],
                          alertDict[@"title"]
                          )];
    }
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

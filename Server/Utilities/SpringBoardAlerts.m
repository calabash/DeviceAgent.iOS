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
static SpringBoardAlert *alert(NSString *buttonTitle, BOOL shouldAccept, NSString *title) {
    return [[SpringBoardAlert alloc] initWithAlertTitleFragment:title
                                             dismissButtonTitle:buttonTitle
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
// The rules how iOS decides which language to choose:
// 1. If preferred language (like Pt-PT) exists / supports, so it will be loaded, short name (pt) and english
// 2. If preferred language dialect doesn't exist, short form will be loaded (Pt-518 we will take Pt) and english
// 3. If preferred language can't be found - only english will be loaded
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
            NSString *fullLanguageName = [validPreferredLanguage stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
            // load full name, it can be "en_GB"
            [self loadLanguageIfExists:fullLanguageName:resultArray];
            NSString *shortLanguageName = [validPreferredLanguage componentsSeparatedByString:@"-"][0];
            // if preferredLanguage is long-term like "en_GB", load "en" too
            [self loadLanguageIfExists:shortLanguageName:resultArray];
        } else {
            [self loadLanguageIfExists:preferredLanguage:resultArray];
        }

        // load "en" just in case
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
// if preferred language is Chinese so we get zn-Hans-US and others. Function should transform them for the alerts
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

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

+ (NSArray<NSString*> *) languagesFromBundle:(NSBundle*) bundle {
    NSString *path = [NSString
                      stringWithFormat: @"%@/Assets.car",
                      [bundle bundlePath]];
    CUICommonAssetStorage *storage =
    [[NSClassFromString(@"CUICommonAssetStorage") alloc] initWithPath:path];
    NSArray *assetNames = [storage allRenditionNames];
    if (!assetNames) return @[];
    if (assetNames.count == 0) return @[];
    NSMutableArray<NSString *> *result =
    [[NSMutableArray alloc] initWithCapacity:assetNames.count];
    for (NSInteger i = 0;i < assetNames.count; i++){
        NSString *name = assetNames[i];
        if ([name hasPrefix: @"springboard-alerts-"]) {
            [result addObject:assetNames[i]];
        }
    };
    return result;
}

- (instancetype)init_private {
    self = [super init];
    if (self) {
        NSTimeInterval startTime = [[CBXMachClock sharedClock] absoluteTime];
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSMutableArray<SpringBoardAlert *> *result =
        [NSMutableArray<SpringBoardAlert *> array];
        
        NSArray<NSString*> *languages =
        [SpringBoardAlerts languagesFromBundle: bundle];
        
        for (NSUInteger languagei = 0; languagei < languages.count; languagei++) {
            NSString *language = languages[languagei];
            NSDataAsset *asset = [[NSDataAsset alloc]
                                  initWithName:language
                                  bundle:bundle];
            
            NSArray *alerts = [NSJSONSerialization
                                JSONObjectWithData:[asset data]
                                options:kNilOptions
                                error:nil];
            for (NSUInteger i=0; i < alerts.count; i++) {
                NSDictionary* alertDict = alerts[i];
                [SpringBoardAlerts raiseIfInvalidAlert:alertDict
                                            ofLanguage:language
                                           andPosition:i];
                [result
                 addObject: alert(
                                  alertDict[@"buttons"],
                                  [alertDict[@"shouldAccept"] boolValue],
                                  alertDict[@"title"]
                                  )];
            }
        }
        _alerts =  [NSArray<SpringBoardAlert *> arrayWithArray: result];
        NSTimeInterval elapsedSeconds =
        [[CBXMachClock sharedClock] absoluteTime] - startTime;
        DDLogDebug(@"SpringBoardAlerts.init_private took %@ seconds",
                   @(elapsedSeconds));
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

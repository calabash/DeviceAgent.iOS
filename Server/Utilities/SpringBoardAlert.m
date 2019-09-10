
#import "SpringBoardAlert.h"

@interface SpringBoardAlert ()

- (instancetype)initWithAlertTitleFragment:(NSString *)alertTitleFragment
                        dismissButtonTitles:(NSArray *)acceptButtonTitles
                              shouldAccept:(BOOL)shouldAccept;

- (BOOL)matchesAlertTitle:(NSString *)alertTitle;

@property(copy, readonly) NSRegularExpression *alertTitleFragment;

@end

@implementation SpringBoardAlert

- (instancetype)initWithAlertTitleFragment:(NSString *)alertTitleFragment
                        dismissButtonTitles:(NSArray *)dismissButtonTitles
                              shouldAccept:(BOOL)shouldAccept {

    self = [super init];
    if (self) {
        // replace "%@", "%1$@", "%2$@" by ".+"
        NSString *tempPattern = [NSString stringWithFormat: alertTitleFragment, @".+", @".+"];
        // escape string for regex, it is necessary because alert title can contain "+", "*", ".", "?" and etc
        tempPattern = [NSRegularExpression escapedPatternForString:(NSString *) tempPattern];
        // apply "^" + string + "$", it needs to match only full alert name
        // allow to avoid issues when one alert is substring of other alert
        tempPattern = [NSString stringWithFormat:@"%@%@%@", @"^", tempPattern, @"$"];
        // fix ".+" after invocation "escapedPatternForString"
        tempPattern = [tempPattern stringByReplacingOccurrencesOfString: @"\\.\\+"
                                                                             withString:@".+"];
        _alertTitleFragment = [NSRegularExpression regularExpressionWithPattern:tempPattern
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];
        _defaultDismissButtonMarks = dismissButtonTitles;
        _shouldAccept = shouldAccept;
    }
    return self;
}

- (BOOL)matchesAlertTitle:(NSString *)alertTitle {                
    NSUInteger numberOfMatches = [self.alertTitleFragment numberOfMatchesInString:alertTitle
                                                        options:0
                                                          range:NSMakeRange(0, [alertTitle length])];

    return numberOfMatches == 1;
}

@end

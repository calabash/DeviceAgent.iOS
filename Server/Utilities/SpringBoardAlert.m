
#import "SpringBoardAlert.h"

@interface SpringBoardAlert ()

- (instancetype)initWithAlertTitleFragment:(NSString *)alertTitleFragment
                        dismissButtonTitle:(NSString *)acceptButtonTitle
                              shouldAccept:(BOOL)shouldAccept;

- (BOOL)matchesAlertTitle:(NSString *)alertTitle;

@property(copy, readonly) NSString *alertTitleFragment;

@end

@implementation SpringBoardAlert

- (instancetype)initWithAlertTitleFragment:(NSString *)alertTitleFragment
                        dismissButtonTitle:(NSString *)dismissButtonTitle
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
        _alertTitleFragment = [tempPattern stringByReplacingOccurrencesOfString: @"\\.\\+"
                                                                             withString:@".+"];
        _defaultDismissButtonMark = dismissButtonTitle;
        _shouldAccept = shouldAccept;
    }
    return self;
}

- (BOOL)matchesAlertTitle:(NSString *)alertTitle {
    return [[alertTitle lowercaseString]
            containsString:[self.alertTitleFragment
                            lowercaseString]];
}

@end

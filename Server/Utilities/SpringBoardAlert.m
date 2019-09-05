
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
        // insert regex in pattern 
        // escape special symbols in alert title (with regex)
        // then add start line and end line symbols in pattern
        // and replace escaped regex with normal regex
        NSString *tempPattern = [NSString stringWithFormat: alertTitleFragment, @".+", @".+"];
        tempPattern = [NSRegularExpression escapedPatternForString:(NSString *) tempPattern];
        tempPattern = [NSString stringWithFormat:@"%@%@%@", @"^", tempPattern, @"$"];
        _alertTitleFragment = [tempPattern stringByReplacingOccurrencesOfString: @"\\.\\+"
                                                                             withString:@".+"];
        _defaultDismissButtonMark = dismissButtonTitle;
        _shouldAccept = shouldAccept;
    }
    return self;
}

- (BOOL)matchesAlertTitle:(NSString *)alertTitle {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:self.alertTitleFragment
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
                         
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:alertTitle
                                                        options:0
                                                          range:NSMakeRange(0, [alertTitle length])];

    return numberOfMatches == 1;
}

@end

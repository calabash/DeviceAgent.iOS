
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
        _alertTitleFragment = alertTitleFragment;
        _defaultDismissButtonMark = dismissButtonTitle;
        _shouldAccept = shouldAccept;
    }
    return self;
}

- (BOOL)matchesAlertTitle:(NSString *)alertTitle {
    NSString *regExPattern = [NSString stringWithFormat: self.alertTitleFragment, @"[a-z0-9-]*", @"[a-z0-9-]*"];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regExPattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
                                                                             
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:alertTitle
                                                        options:0
                                                          range:NSMakeRange(0, [alertTitle length])];

    return numberOfMatches == 1;
}

@end

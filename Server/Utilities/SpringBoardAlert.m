
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
        _alertTitleFragment = [NSString stringWithFormat: [NSRegularExpression escapedPatternForString:(NSString *) alertTitleFragment], @"\\S+", @"\\S+"];
        _defaultDismissButtonMark = dismissButtonTitle;
        _shouldAccept = shouldAccept;
    }
    return self;
}

- (BOOL)matchesAlertTitle:(NSString *)alertTitle {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:self.alertTitleFragment
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    // NSLog(@"----------");
    // NSLog(@"alert title: %@", alertTitle);
    // NSLog(@"alert regex: %@", regex);
                                                                             
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:alertTitle
                                                        options:0
                                                          range:NSMakeRange(0, [alertTitle length])];

    return numberOfMatches == 1;
}

@end


#import "SpringBoardAlert.h"

@interface SpringBoardAlert ()

- (instancetype)initWithAlertTitleFragment:(NSString *)alertTitleFragment
                        dismissButtonTitles:(NSArray *)acceptButtonTitles
                              shouldAccept:(BOOL)shouldAccept;

- (BOOL)matchesAlertTitle:(NSString *)alertTitle;

@property(copy, readonly) NSString *alertTitleFragment;

@end

@implementation SpringBoardAlert

- (instancetype)initWithAlertTitleFragment:(NSString *)alertTitleFragment
                        dismissButtonTitles:(NSArray *)dismissButtonTitles
                              shouldAccept:(BOOL)shouldAccept {

    self = [super init];
    if (self) {
        _alertTitleFragment = alertTitleFragment;
        _defaultDismissButtonMarks = dismissButtonTitles;
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

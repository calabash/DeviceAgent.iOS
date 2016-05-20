#import "TaoController.h"

@interface TaoController ()
@property (weak, nonatomic) IBOutlet UILabel *touchActionLabel;
@property (weak, nonatomic) IBOutlet UIView *doubleTap;
@property (weak, nonatomic) IBOutlet UIView *tap;
@property (weak, nonatomic) IBOutlet UIView *longPress;
@property (weak, nonatomic) IBOutlet UIView *twoFingerTap;
@property (weak, nonatomic) IBOutlet UIView *tripleTap;
@property (weak, nonatomic) IBOutlet UIView *twoFingerLongPress;
@property (weak, nonatomic) IBOutlet UIView *threeFingerTap;
@property (weak, nonatomic) IBOutlet UIView *twoFingerDoubleTap;
@property (strong, nonatomic) IBOutlet UILabel *centerLabel;

@end

@implementation TaoController

#pragma mark - Actions

- (void)handleTapOnCenterLabel:(UIGestureRecognizer *)recognizer {
    UIGestureRecognizerState state = [recognizer state];
    if (UIGestureRecognizerStateEnded == state) {
        self.centerLabel.text = @"TOUCHED";
    }
}

- (void)handleTapOnTouchActionLabel:(UIGestureRecognizer *)recognizer {
    UIGestureRecognizerState state = [recognizer state];
    if (UIGestureRecognizerStateEnded == state) {
        self.touchActionLabel.text = @"CLEARED";
    }
}

- (void)handleDoubleTap:(UIGestureRecognizer *)recognizer {
    UIGestureRecognizerState state = [recognizer state];
    if (UIGestureRecognizerStateEnded == state) {
        self.touchActionLabel.text = @"double tap";
    }
}

#pragma mark - Recognizers

- (UITapGestureRecognizer *)tapRecognizerWithSelector:(SEL)selector
                                                 taps:(NSUInteger)taps
                                              touches:(NSUInteger)touches {
    UITapGestureRecognizer *recognizer;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                         action:selector];
    recognizer.numberOfTapsRequired = taps;
    recognizer.numberOfTouchesRequired = touches;
    return recognizer;
}

#pragma mark - Orientation / Rotation

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
    return YES;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    UIGestureRecognizer *recognizer;
    recognizer = [self tapRecognizerWithSelector:@selector(handleTapOnTouchActionLabel:)
                                            taps:1
                                         touches:1];

    self.touchActionLabel.userInteractionEnabled = YES;
    [self.touchActionLabel
     addGestureRecognizer:[self tapRecognizerWithSelector:@selector(handleTapOnTouchActionLabel:)
                                                     taps:1
                                                  touches:1]];


    self.centerLabel.userInteractionEnabled = YES;
    [self.centerLabel
     addGestureRecognizer:[self tapRecognizerWithSelector:@selector(handleTapOnCenterLabel:)
                                                     taps:1
                                                  touches:1]];

    recognizer = [self tapRecognizerWithSelector:@selector(handleDoubleTap:)
                                            taps:2
                                         touches:1];
    [self.doubleTap addGestureRecognizer:recognizer];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

@end

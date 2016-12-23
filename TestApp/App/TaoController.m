#import "TaoController.h"

@interface TaoController ()
@property (weak, nonatomic) IBOutlet UILabel *smallButtonActionLabel;
@property (weak, nonatomic) IBOutlet UIView *doubleTap;
@property (weak, nonatomic) IBOutlet UIView *touch;
@property (weak, nonatomic) IBOutlet UIView *longPress;
@property (weak, nonatomic) IBOutlet UIView *twoFingerTap;
@property (weak, nonatomic) IBOutlet UIView *tripleTap;
@property (weak, nonatomic) IBOutlet UIView *twoFingerLongPress;
@property (weak, nonatomic) IBOutlet UIView *threeFingerTap;
@property (weak, nonatomic) IBOutlet UIView *twoFingerDoubleTap;
@property (weak, nonatomic) IBOutlet UILabel *complexTouchesLabel;
@property (weak, nonatomic) IBOutlet UIView *fourFingerTap;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation TaoController

#pragma mark - Actions

- (void)handleTapOnTouchActionLabel:(UIGestureRecognizer *)recognizer {
    UIGestureRecognizerState state = [recognizer state];
    if (UIGestureRecognizerStateEnded == state) {
        UILabel *label = (UILabel *)recognizer.view;
        label.text = @"CLEARED";
    }
}

- (void)handleDoubleTapOnSmallButton:(UIGestureRecognizer *)recognizer {
    UIGestureRecognizerState state = [recognizer state];
    if (UIGestureRecognizerStateEnded == state) {
        self.smallButtonActionLabel.text = @"double tap";
    }
}

- (void)handleTouchOnSmallButton:(UIGestureRecognizer *)recognizer {
    UIGestureRecognizerState state = [recognizer state];
    if (UIGestureRecognizerStateEnded == state) {
        self.smallButtonActionLabel.text = @"touch";
    }
}

- (void)handleLongPressOnSmallButton:(UIGestureRecognizer *)recognizer {
    UIGestureRecognizerState state = [recognizer state];
    if (UIGestureRecognizerStateEnded == state) {
        self.smallButtonActionLabel.text = @"long press";
    }
}

- (void)handleTripleTapOnSmallButton:(UIGestureRecognizer *)recognizer {
    UIGestureRecognizerState state = [recognizer state];
    if (UIGestureRecognizerStateEnded == state) {
        self.smallButtonActionLabel.text = @"triple tap";
    }
}

- (void)handleTwoFingerTap:(UIGestureRecognizer *)recognizer {
    UIGestureRecognizerState state = [recognizer state];
    if (UIGestureRecognizerStateEnded == state) {
        self.complexTouchesLabel.text = @"two-finger tap";
    }
}

- (void)handleThreeFingerTap:(UIGestureRecognizer *)recognizer {
    UIGestureRecognizerState state = [recognizer state];
    if (UIGestureRecognizerStateEnded == state) {
        self.complexTouchesLabel.text = @"three-finger tap";
    }
}

- (void)handleFourFingerTap:(UIGestureRecognizer *)recognizer {
    UIGestureRecognizerState state = [recognizer state];
    if (UIGestureRecognizerStateEnded == state) {
        self.complexTouchesLabel.text = @"four-finger tap";
    }
}

- (void)handleTwoFingerDoubleTap:(UIGestureRecognizer *)recognizer {
    UIGestureRecognizerState state = [recognizer state];
    if (UIGestureRecognizerStateEnded == state) {
        self.complexTouchesLabel.text = @"two-finger double tap";
    }
}

- (void)handleTwoFingerLongpress:(UIGestureRecognizer *)recognizer {
    UIGestureRecognizerState state = [recognizer state];
    if (UIGestureRecognizerStateEnded == state) {
        self.complexTouchesLabel.text = @"two-finger long press";
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGPoint offset = sender.contentOffset;
    [sender setContentOffset:CGPointMake(0, offset.y)];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    UIGestureRecognizer *recognizer;
    recognizer = [self tapRecognizerWithSelector:@selector(handleTapOnTouchActionLabel:)
                                            taps:1
                                         touches:1];

    self.smallButtonActionLabel.userInteractionEnabled = YES;
    [self.smallButtonActionLabel addGestureRecognizer:recognizer];

    recognizer = [self tapRecognizerWithSelector:@selector(handleTapOnTouchActionLabel:)
                                            taps:1
                                         touches:1];
    self.complexTouchesLabel.userInteractionEnabled = YES;
    [self.complexTouchesLabel addGestureRecognizer:recognizer];

    recognizer = [self tapRecognizerWithSelector:@selector(handleDoubleTapOnSmallButton:)
                                            taps:2
                                         touches:1];
    [self.doubleTap addGestureRecognizer:recognizer];

    recognizer = [self tapRecognizerWithSelector:@selector(handleTouchOnSmallButton:)
                                            taps:1
                                         touches:1];
    [self.touch addGestureRecognizer:recognizer];

    recognizer = [self tapRecognizerWithSelector:@selector(handleTripleTapOnSmallButton:)
                                            taps:3
                                         touches:1];
    [self.tripleTap addGestureRecognizer:recognizer];

    recognizer = [self tapRecognizerWithSelector:@selector(handleTwoFingerTap:)
                                            taps:1
                                         touches:2];
    [self.twoFingerTap addGestureRecognizer:recognizer];

    recognizer = [self tapRecognizerWithSelector:@selector(handleThreeFingerTap:)
                                            taps:1
                                         touches:3];
    [self.threeFingerTap addGestureRecognizer:recognizer];

    recognizer = [self tapRecognizerWithSelector:@selector(handleFourFingerTap:)
                                            taps:1
                                         touches:4];
    [self.fourFingerTap addGestureRecognizer:recognizer];

    recognizer = [self tapRecognizerWithSelector:@selector(handleTwoFingerDoubleTap:)
                                            taps:2
                                         touches:2];
    [self.twoFingerDoubleTap addGestureRecognizer:recognizer];

    UILongPressGestureRecognizer *lpRecognizer;
    lpRecognizer = [[UILongPressGestureRecognizer alloc]
                    initWithTarget:self
                    action:@selector(handleLongPressOnSmallButton:)];
    lpRecognizer.minimumPressDuration = 1.0;
    lpRecognizer.numberOfTouchesRequired = 1;
    [self.longPress addGestureRecognizer:lpRecognizer];

    lpRecognizer = [[UILongPressGestureRecognizer alloc]
                    initWithTarget:self
                    action:@selector(handleTwoFingerLongpress:)];
    lpRecognizer.minimumPressDuration = 1.0;
    lpRecognizer.numberOfTouchesRequired = 2;
    [self.complexTouchesLabel addGestureRecognizer:lpRecognizer];
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

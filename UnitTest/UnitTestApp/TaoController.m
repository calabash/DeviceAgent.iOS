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

@end

@implementation TaoController

#pragma mark - Actions

- (void)handleDoubleTap:(UIGestureRecognizer *)recognizer {
    UIGestureRecognizerState state = [recognizer state];
    if (UIGestureRecognizerStateEnded == state) {
        self.touchActionLabel.text = @"double tap";
    }
}

#pragma mark - Recognizers

- (UIGestureRecognizer *) doubleTapRecognizer {
    SEL selector = @selector(handleDoubleTap:);
    UITapGestureRecognizer *recognizer;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                         action:selector];
    recognizer.numberOfTapsRequired = 2;
    recognizer.numberOfTouchesRequired = 1;
    return recognizer;
}

#pragma mark - Orientation / Rotation

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL) shouldAutorotate {
    return YES;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.doubleTap addGestureRecognizer:[self doubleTapRecognizer]];
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void) viewDidLayoutSubviews {
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

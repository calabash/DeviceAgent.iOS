#import "TouchViewController.h"
#import "UIView+Positioning.h"

@interface TouchViewController ()

@property(strong, nonatomic) UIButton *hiddenButton;
- (void)hiddenButtonTouched:(id)sender;

@property(strong, nonatomic) UIButton *mostlyHiddenButton;
- (void)mostlyHiddenButtonTouched:(id)sender;

@property(strong, nonatomic) UIButton *mostlyVisibleButton;
- (void)mostlyVisibleButtonTouched:(id)sender;

@property(strong, nonatomic) UIButton *offScreenButton;
- (void)offScreenButtonTouched:(id)sender;

@property(strong, nonatomic) UIButton *rightMidPointButton;
- (void)rightMidPointButtonTouched:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *alphaButton;
- (IBAction)alphaButtonTouched:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *zeroButton;
- (IBAction)zeroButtonTouched:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *animatedButton;
- (IBAction)animatedButtonTouched:(id)sender;

- (void)presentAlertWithTitle:(NSString *)title
                      message:(NSString *)message;

- (void)handleTapOnPurpleLabel:(UITapGestureRecognizer *) recognizer;
- (void)handleTwoFingerTapOnAnimatedButton:(UITapGestureRecognizer *)recognizer;

- (UIButton *)buttonWithIdentifier:(NSString *) identifier
                             title:(NSString *) title
                          selector:(SEL) selector;
@end

@implementation TouchViewController

@synthesize hiddenButton = _hiddenButton;
@synthesize mostlyHiddenButton = _mostlyHiddenButton;
@synthesize mostlyVisibleButton = _mostlyVisibleButton;
@synthesize offScreenButton = _offScreenButton;
@synthesize rightMidPointButton = _rightMidPointButton;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UILongPressGestureRecognizer *longPress = [self recognizerWithClass:[UILongPressGestureRecognizer class]];
        UITapGestureRecognizer *touch = [self recognizerWithClass:[UITapGestureRecognizer class]];
        UITapGestureRecognizer *doubleTap = [self recognizerWithClass:[UITapGestureRecognizer class]];
        doubleTap.numberOfTapsRequired = 2;
        UITapGestureRecognizer *twoFingerTap = [self recognizerWithClass:[UITapGestureRecognizer class]];
        twoFingerTap.numberOfTouchesRequired = 2;

        self.gestureRecognizers = @[touch, doubleTap, longPress, twoFingerTap];
    }
    return self;
}

#pragma mark - Subviews

- (UIButton *)hiddenButton {
    if (_hiddenButton) { return _hiddenButton; }

    _hiddenButton = [self buttonWithIdentifier:@"hidden button"
                                         title:@"Hidden Button"
                                      selector:@selector(hiddenButtonTouched:)];
    return _hiddenButton;
}

- (UIButton *)mostlyHiddenButton {
    if (_mostlyHiddenButton) { return _mostlyHiddenButton; }
    _mostlyHiddenButton = [self buttonWithIdentifier:@"mostly hidden button"
                                               title:@"Mostly Hidden"
                                            selector:@selector(mostlyHiddenButtonTouched:)];
    return _mostlyHiddenButton;
}

- (UIButton *)mostlyVisibleButton {
    if (_mostlyVisibleButton) { return _mostlyVisibleButton; }
    _mostlyVisibleButton = [self buttonWithIdentifier:@"mostly visible button"
                                                title:@"Mostly Visible"
                                             selector:@selector(mostlyVisibleButtonTouched:)];
    return _mostlyVisibleButton;
}

- (UIButton *)offScreenButton {
    if (_offScreenButton) { return _offScreenButton; }
    _offScreenButton = [self buttonWithIdentifier:@"off screen button"
                                            title:@"Off Screen Button"
                                         selector:@selector(offScreenButtonTouched:)];

    return _offScreenButton;
}

- (UIButton *)rightMidPointButton {
    if (_rightMidPointButton) { return _rightMidPointButton; }
    UIButton *button = [self buttonWithIdentifier:@"right mid point button"
                                            title:@""
                                         selector:@selector(rightMidPointButtonTouched:)];
    button.backgroundColor = [UIColor clearColor];
    button.height = 4;
    button.width = 4;

    _rightMidPointButton = button;

    return button;
}

- (UIButton *)buttonWithIdentifier:(NSString *) identifier
                         title:(NSString *) title
                      selector:(SEL) selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 100, 25);
    button.accessibilityIdentifier = identifier;
    [button setTitle:title forState:UIControlStateNormal];
    UIColor *color = [UIColor greenColor];
    [button setBackgroundColor:color];
    [button addTarget:self
               action:selector
     forControlEvents:UIControlEventTouchUpInside];

    return button;
}

#pragma mark - Actions

- (IBAction)alphaButtonTouched:(id)sender {
    __weak UIButton *button = self.alphaButton;

    // If we use an animation, the button remains hittable!
    button.alpha = 0.0;
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW,
                                         4.0 * NSEC_PER_SEC);
    dispatch_after(when, dispatch_get_main_queue(), ^{
        button.alpha = 1.0;
    });
}

- (IBAction)zeroButtonTouched:(id)sender {
    __weak UIButton *button = self.zeroButton;

    CGSize originalSize = button.size;
    button.size = CGSizeZero;

    // If we use an animation, the button remains hittable!
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW,
                                         4.0 * NSEC_PER_SEC);
    dispatch_after(when, dispatch_get_main_queue(), ^{
        button.size = originalSize;
    });
}

- (void)handleTwoFingerTapOnAnimatedButton:(UITapGestureRecognizer *)recognizer {
    UIGestureRecognizerState state = [recognizer state];
    if (UIGestureRecognizerStateEnded == state) {
        NSTimeInterval duration = 1.0;

        UIViewAnimationOptions options = (
                                          UIViewAnimationOptionAllowUserInteraction |
                                          UIViewAnimationOptionCurveEaseIn
                                          );
        UIButton *button = (UIButton *)recognizer.view;

        [UIView animateWithDuration:duration
                              delay:0.0
                            options:options
                         animations:^{
                             button.transform = CGAffineTransformMakeScale(0.0, 0.0);
                         }
                         completion:^(BOOL finished) {
                             [button setTitle:@"Animated" forState:UIControlStateNormal];
                         }];

        [UIView animateWithDuration:duration
                              delay:3.0
                            options:options
                         animations:^{
                             button.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             [button setTitle:@"Had Size Zero" forState:UIControlStateNormal];
                         }];
    }
}

- (IBAction)animatedButtonTouched:(id)sender {
    __weak UIButton *button = self.animatedButton;
    NSTimeInterval duration = 1.0;

    UIViewAnimationOptions options = (
                                      UIViewAnimationOptionAllowUserInteraction |
                                      UIViewAnimationOptionCurveEaseIn
                                      );

    [UIView animateWithDuration:duration
                          delay:0.0
                        options:options
                     animations:^{
                         button.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [button setTitle:@"Animated" forState:UIControlStateNormal];
                     }];

    [UIView animateWithDuration:duration
                          delay:3.0
                        options:options
                     animations:^{
                         button.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [button setTitle:@"Had Alpha Zero" forState:UIControlStateNormal];

                     }];
}

- (void)presentAlertWithTitle:(NSString *)title
                      message:(NSString *)message {
    UIAlertController *controller =
    [UIAlertController
    alertControllerWithTitle:title
     message:message
     preferredStyle:UIAlertControllerStyleAlert];

    [controller addAction:[UIAlertAction
                           actionWithTitle:@"OK"
                           style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
                           {
                               [self dismissViewControllerAnimated:YES completion:nil];
                           }]];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)hiddenButtonTouched:(id)sender {
   [self presentAlertWithTitle:@"Hidden Button"
                       message:@"If we can't see you, how can we touch you?"];
}

- (void)mostlyHiddenButtonTouched:(id)sender {
   [self presentAlertWithTitle:@"Mostly Hidden Button"
                       message:@"If we can see part of you, we can touch you."];
}

- (void)mostlyVisibleButtonTouched:(id)sender {
   [self presentAlertWithTitle:@"Mostly Visible Button"
                       message:@"If we can see most of you, we can touch you."];
}

// This button can never be touched.
- (void)offScreenButtonTouched:(id)sender {
   [self presentAlertWithTitle:@"Off Screen"
                       message:@"If you are off the screen, how can we touch you?"];
}

// This button is touched when trying to touch the off screen button.
- (void)rightMidPointButtonTouched:(id)sender {
   [self presentAlertWithTitle:@"Off Screen Touch!?!"
                       message:@"The button you tried to touch is off screen, \
you touched me instead!\
\
Touches with coordinates that are off screen happen at closest screen edge."];
}

- (void)handleTapOnPurpleLabel:(UITapGestureRecognizer *) recognizer {
    UIGestureRecognizerState state = [recognizer state];
    if (UIGestureRecognizerStateEnded == state) {
        NSUInteger fingers = recognizer.numberOfTouchesRequired;
        if (fingers == 1) {
            self.gestureLabel.text = @"That was touching.";
        } else if (fingers == 2) {
            self.gestureLabel.text = @"CLEARED";
        }
    }
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
    self.gestureLabel.accessibilityIdentifier = @"gesture performed";

    UITapGestureRecognizer *tapRecognizer;
    tapRecognizer = [[UITapGestureRecognizer alloc]
                  initWithTarget:self
                  action:@selector(handleTapOnPurpleLabel:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;

    [self.gestureLabel addGestureRecognizer:tapRecognizer];

    tapRecognizer = [[UITapGestureRecognizer alloc]
                  initWithTarget:self
                  action:@selector(handleTapOnPurpleLabel:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 2;

    [self.gestureLabel addGestureRecognizer:tapRecognizer];

    tapRecognizer = [[UITapGestureRecognizer alloc]
                     initWithTarget:self
                     action:@selector(handleTwoFingerTapOnAnimatedButton:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 2;

    [self.animatedButton addGestureRecognizer:tapRecognizer];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    // Handle rotation events.
    [self.hiddenButton removeFromSuperview];
    [self.mostlyHiddenButton removeFromSuperview];
    [self.mostlyVisibleButton removeFromSuperview];
    [self.offScreenButton removeFromSuperview];
    [self.rightMidPointButton removeFromSuperview];

    UIButton *button;

    button = self.mostlyHiddenButton;
    button.x = self.gestureLabel.x + 8;
    button.centerY = self.gestureLabel.y + (button.height/2.0) - 10;
    [self.view insertSubview:button belowSubview:self.gestureLabel];

    button = self.mostlyVisibleButton;
    button.centerX = self.gestureLabel.centerX;
    button.centerY = self.gestureLabel.y + (button.height/2.0) - 16;
    [self.view insertSubview:button belowSubview:self.gestureLabel];

    button = self.hiddenButton;
    button.x = self.gestureLabel.right - (button.width + 8);
    button.centerY = self.gestureLabel.centerY;
    [self.view insertSubview:button belowSubview:self.gestureLabel];

    button = self.offScreenButton;
    button.x = self.view.right + button.width + 50;
    button.centerY = self.view.centerY;
    [self.view addSubview:button];

    button = self.rightMidPointButton;
    button.x = self.view.right - button.width;
    button.centerY = self.view.centerY;
    [self.view addSubview:button];
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

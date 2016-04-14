
#import "FirstViewController.h"

@interface FirstViewController ()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *gestureLabel;

@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchRecognizer;
@property (nonatomic, strong) UIRotationGestureRecognizer *rotationRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressRecognizer;

@property (nonatomic, strong) NSMutableArray<CALayer *> *drawings;

- (void)recognizeGesture:(UIGestureRecognizer *)recognizer;

@end

@implementation FirstViewController

static NSDictionary *colors;

+ (void)initialize {
    colors = @{
               @(0) : [UIColor blueColor],
               @(1) : [UIColor redColor],
               @(2) : [UIColor greenColor],
               @(3) : [UIColor purpleColor],
               @(4) : [UIColor darkGrayColor]
               };
}

- (void)updateGestureLabelText:(NSString *)text
                    recognizer:(UIGestureRecognizer *)handledRecognizer {
    for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
        if (recognizer == handledRecognizer) {
            self.gestureLabel.text = text;
            break;
        }
    }
}

- (NSString *)textForRecognizer:(UIGestureRecognizer *)recognizer {
    if (recognizer == self.panRecognizer) {
        return @"Pan";
    } else if (recognizer == self.swipeRecognizer) {
        return @"Swipe";
    }  else if (recognizer == self.tapRecognizer) {
        return @"Tap";
    } else if (recognizer == self.pinchRecognizer) {
        return @"Pinch";
    } else if (recognizer == self.rotationRecognizer) {
        return @"Rotation";
    } else if (recognizer == self.longPressRecognizer) {
        return @"Long Press";
    } else if (recognizer == self.doubleTapRecognizer) {
        return @"Double Tap";
    } else {
        return @"Unknown Gesture";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _drawings = [NSMutableArray array];

    SEL selector = @selector(recognizeGesture:);
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                 action:selector];
    [self.view addGestureRecognizer:self.panRecognizer];

    self.swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                     action:selector];

    [self.view addGestureRecognizer:self.swipeRecognizer];

    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                 action:selector];
    [self.view addGestureRecognizer:self.tapRecognizer];

    self.pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                     action:selector];
    [self.view addGestureRecognizer:self.pinchRecognizer];

    self.longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                             action:selector];
    [self.view addGestureRecognizer:self.longPressRecognizer];

    self.doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                       action:selector];
    self.doubleTapRecognizer.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:self.doubleTapRecognizer];
}

- (void)recognizeGesture:(UIGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan ||
        recognizer == _tapRecognizer) {
        for (CALayer *layer in _drawings) {
            [layer removeFromSuperlayer];
        }
    }

    NSString *text = [self textForRecognizer:recognizer];
    [self updateGestureLabelText:text recognizer:recognizer];

    /*
     http://stackoverflow.com/questions/16846413/how-do-you-draw-a-line-programmatically-from-a-view-controller
     
     Iterate through all touches, mapping each one to a different color.
     This becomes buggy if a finger leaves mid-gesture, but probably
     beyond the scope of our testing here.
     */
    for (int i = 0; i < [recognizer numberOfTouches]; i++) {
        CGPoint p = [recognizer locationOfTouch:i inView:self.view];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(p.x, p.y, 3, 3) cornerRadius:1];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = [path CGPath];
        UIColor *color = colors[@(i)];
        shapeLayer.strokeColor = [color CGColor];
        shapeLayer.lineWidth = 3.0;
        shapeLayer.fillColor = [color CGColor];
        [_drawings addObject:shapeLayer];
        [self.view.layer addSublayer:shapeLayer];
    }

    [self.view bringSubviewToFront:_gestureLabel];
}

@end

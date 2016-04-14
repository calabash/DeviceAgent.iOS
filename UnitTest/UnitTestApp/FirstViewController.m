
#import "FirstViewController.h"

@interface FirstViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchRecognizer;
@property (nonatomic, strong) UIRotationGestureRecognizer *rotationRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressRecognizer;

@property (nonatomic, strong) NSMutableArray<CALayer *> *drawings;

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

#define MakeGestureRecognizer(class) [[class alloc] initWithTarget:self action:@selector(recognizeGesture:)]
#define MatchGestureRecognizer(gr1, gr2, label) if (gr1 == gr2) { _gestureLabel.text = label; }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _drawings = [NSMutableArray array];
    
    _panRecognizer =  MakeGestureRecognizer(UIPanGestureRecognizer);
    _swipeRecognizer = MakeGestureRecognizer(UISwipeGestureRecognizer);
    _tapRecognizer = MakeGestureRecognizer(UITapGestureRecognizer);
    _pinchRecognizer = MakeGestureRecognizer(UIPinchGestureRecognizer);
    _rotationRecognizer = MakeGestureRecognizer(UIRotationGestureRecognizer);
    _longPressRecognizer = MakeGestureRecognizer(UILongPressGestureRecognizer);
    _doubleTapRecognizer = MakeGestureRecognizer(UITapGestureRecognizer);
    _doubleTapRecognizer.numberOfTapsRequired = 2;
    
    for (UIGestureRecognizer *gr in @[_panRecognizer,
                                      _swipeRecognizer,
                                      _tapRecognizer,
                                      _pinchRecognizer,
                                      _rotationRecognizer,
                                      _longPressRecognizer,
                                      _doubleTapRecognizer]) {
        [self.view addGestureRecognizer:gr];
    }
}

- (void)recognizeGesture:(UIGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan ||
        recognizer == _tapRecognizer) {
        for (CALayer *layer in _drawings) {
            [layer removeFromSuperlayer];
        }
    }
    
    MatchGestureRecognizer(recognizer, _panRecognizer, @"Pan");
    MatchGestureRecognizer(recognizer, _swipeRecognizer, @"Swipe");
    MatchGestureRecognizer(recognizer, _tapRecognizer, @"Tap");
    MatchGestureRecognizer(recognizer, _pinchRecognizer, @"Pinch");
    MatchGestureRecognizer(recognizer, _rotationRecognizer, @"Rotation");
    MatchGestureRecognizer(recognizer, _longPressRecognizer, @"Long Press");
    MatchGestureRecognizer(recognizer, _doubleTapRecognizer, @"Double Tap");
    
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

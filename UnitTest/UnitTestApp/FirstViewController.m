
#import "FirstViewController.h"

@interface FirstViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *panGR;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGR;
@property (nonatomic, strong) UITapGestureRecognizer *tapGR;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGR;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGR;
@property (nonatomic, strong) UIRotationGestureRecognizer *rotationGR;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGR;

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
    
    _panGR =  MakeGestureRecognizer(UIPanGestureRecognizer);
    _swipeGR = MakeGestureRecognizer(UISwipeGestureRecognizer);
    _tapGR = MakeGestureRecognizer(UITapGestureRecognizer);
    _pinchGR = MakeGestureRecognizer(UIPinchGestureRecognizer);
    _rotationGR = MakeGestureRecognizer(UIRotationGestureRecognizer);
    _longPressGR = MakeGestureRecognizer(UILongPressGestureRecognizer);
    _doubleTapGR = MakeGestureRecognizer(UITapGestureRecognizer);
    _doubleTapGR.numberOfTapsRequired = 2;
    
    for (UIGestureRecognizer *gr in @[_panGR,
                                      _swipeGR,
                                      _tapGR,
                                      _pinchGR,
                                      _rotationGR,
                                      _longPressGR,
                                      _doubleTapGR]) {
        [self.view addGestureRecognizer:gr];
    }
}

- (void)recognizeGesture:(UIGestureRecognizer *)gr {
    if (gr.state == UIGestureRecognizerStateBegan || gr == _tapGR) {
        for (CALayer *layer in _drawings) {
            [layer removeFromSuperlayer];
        }
    }
    
    MatchGestureRecognizer(gr, _panGR, @"Pan");
    MatchGestureRecognizer(gr, _swipeGR, @"Swipe");
    MatchGestureRecognizer(gr, _tapGR, @"Tap");
    MatchGestureRecognizer(gr, _pinchGR, @"Pinch");
    MatchGestureRecognizer(gr, _rotationGR, @"Rotation");
    MatchGestureRecognizer(gr, _longPressGR, @"Long Press");
    MatchGestureRecognizer(gr, _doubleTapGR, @"Double Tap");
    
    /*
     http://stackoverflow.com/questions/16846413/how-do-you-draw-a-line-programmatically-from-a-view-controller
     
        Iterate through all touches, mapping each one to a different color. 
        This becomes buggy if a finger leaves mid-gesture, but probably
        beyond the scope of our testing here. 
     */
    
    for (int i = 0; i < [gr numberOfTouches]; i++) {
        CGPoint p = [gr locationOfTouch:i inView:self.view];
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

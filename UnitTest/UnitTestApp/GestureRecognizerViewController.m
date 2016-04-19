
#import "GestureRecognizerViewController.h"

@interface GestureRecognizerViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray<CALayer *> *drawings;

- (void)recognizeGesture:(UIGestureRecognizer *)recognizer;

@end

@implementation GestureRecognizerViewController

@synthesize gestureLabel = _gestureLabel;

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
    if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return @"Pan";
    } else if ([recognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        return @"Swipe";
    }  else if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)recognizer;
        if (tap.numberOfTapsRequired == 2) {
            return @"Double Tap";
        } else if (tap.numberOfTouchesRequired == 2) {
            return @"Two-finger Tap";
        } else {
            return @"Tap";
        }
    } else if ([recognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        return @"Pinch";
    } else if ([recognizer isKindOfClass:[UIRotationGestureRecognizer class]]) {
        return @"Rotation";
    } else if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return @"Long Press";
    } else {
        return @"Unknown Gesture";
    }
}

- (id)recognizerWithClass:(Class)c {
    return [((UIGestureRecognizer *)[c alloc]) initWithTarget:self action:@selector(recognizeGesture:)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _drawings = [NSMutableArray array];
    
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
        [self.view addGestureRecognizer:recognizer];
    }
}

- (void)recognizeGesture:(UIGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan ||
        [recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
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

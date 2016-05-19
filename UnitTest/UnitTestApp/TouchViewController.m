#import "TouchViewController.h"

@interface TouchViewController ()
@property (weak, nonatomic) IBOutlet UILabel *actionLabel;
@property (weak, nonatomic) IBOutlet UIView *doubleTap;
@property (weak, nonatomic) IBOutlet UIView *tap;
@property (weak, nonatomic) IBOutlet UIView *longPress;
@property (weak, nonatomic) IBOutlet UIView *twoFingerTap;
@property (weak, nonatomic) IBOutlet UIView *tripleTap;
@property (weak, nonatomic) IBOutlet UIView *twoFingerLongPress;
@property (weak, nonatomic) IBOutlet UIView *threeFingerTap;
@property (weak, nonatomic) IBOutlet UIView *twoFingerDoubleTap;

@end

@implementation TouchViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gestureLabel.accessibilityIdentifier = @"gesture performed";
}

@end

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

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Actions

- (void)handleDoubleTap:(UIGestureRecognizer *)recognizer {
  UIGestureRecognizerState state = [recognizer state];
  if (UIGestureRecognizerStateEnded == state) {
    self.touchActionLabel.text = @"double tap";
  }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

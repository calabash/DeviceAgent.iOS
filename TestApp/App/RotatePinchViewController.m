
#import "RotatePinchViewController.h"

@interface RotatePinchViewController ()

@end

@implementation RotatePinchViewController
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UIPinchGestureRecognizer *pinch = [self recognizerWithClass:[UIPinchGestureRecognizer class]];
        UIRotationGestureRecognizer *rotate = [self recognizerWithClass:[UIRotationGestureRecognizer class]];
        
        self.gestureRecognizers = @[pinch, rotate];
    }
    return self;
}

@end

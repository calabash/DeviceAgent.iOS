
#import "PanViewController.h"

@interface PanViewController ()

@end

@implementation PanViewController
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UIPanGestureRecognizer *pan = [self recognizerWithClass:[UIPanGestureRecognizer class]];
        
        self.gestureRecognizers = @[pan];
    }
    return self;
}

@end

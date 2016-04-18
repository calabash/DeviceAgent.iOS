#import "TouchViewController.h"

@interface TouchViewController ()

@end

@implementation TouchViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UILongPressGestureRecognizer *longPress = [self recognizerWithClass:[UILongPressGestureRecognizer class]];
        UITapGestureRecognizer *touch = [self recognizerWithClass:[UITapGestureRecognizer class]];
        UITapGestureRecognizer *doubleTap = [self recognizerWithClass:[UITapGestureRecognizer class]];
        doubleTap.numberOfTapsRequired = 2;
        
        self.gestureRecognizers = @[touch, doubleTap, longPress];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gestureLabel.accessibilityIdentifier = @"gesture performed";
}

@end

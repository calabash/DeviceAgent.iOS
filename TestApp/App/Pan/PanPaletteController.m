
#import "PanPaletteController.h"

@interface PanPaletteController ()

- (void)handleTapOnActionLabel:(UITapGestureRecognizer *)recognizer;

@end

@implementation PanPaletteController
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UIPanGestureRecognizer *pan = [self recognizerWithClass:[UIPanGestureRecognizer class]];

        self.gestureRecognizers = @[pan];

    }
    return self;
}

- (void)handleTapOnActionLabel:(UITapGestureRecognizer *)recognizer {
    UIGestureRecognizerState state = [recognizer state];
    if (UIGestureRecognizerStateEnded == state) {
        UILabel *label = (UILabel *)recognizer.view;
        label.text = @"CLEARED";
    }
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tapRecognizer;
    tapRecognizer = [[UITapGestureRecognizer alloc]
                     initWithTarget:self
                     action:@selector(handleTapOnActionLabel:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;

    [self.gestureLabel addGestureRecognizer:tapRecognizer];
}

@end

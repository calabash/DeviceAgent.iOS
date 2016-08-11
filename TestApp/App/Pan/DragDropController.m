
#import "DragDropController.h"

typedef enum : NSInteger {
    kTagRedImageView = 3030,
    kTagBlueImageView,
    kTagGreenImageView
} ViewTags;

@interface DragDropController ()
<UIAlertViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *redImageView;
@property (weak, nonatomic) IBOutlet UIImageView *blueImageView;
@property (weak, nonatomic) IBOutlet UIImageView *greenImageView;
@property (weak, nonatomic) IBOutlet UIView *leftDropTarget;
@property (weak, nonatomic) IBOutlet UIView *rightDropTarget;

@property (strong, nonatomic) UIImageView *dragObject;
@property (assign, nonatomic) CGPoint touchOffset;
@property (assign, nonatomic) CGPoint homePosition;

@property (strong, nonatomic, readonly) UIColor *redColor;
@property (strong, nonatomic, readonly) UIColor *blueColor;
@property (strong, nonatomic, readonly) UIColor *greenColor;

- (UIColor *)colorForImageView:(UIImageView *)imageView;
- (BOOL)touchPointIsLeftWell:(CGPoint)touchPoint;
- (BOOL)touchPointIsRightWell:(CGPoint)touchPoint;
- (BOOL)touchPoint:(CGPoint)touchPoint isWithFrame:(CGRect)frame;

@end

@implementation DragDropController

// http://www.edumobile.org/ios/simple-drag-and-drop-on-iphone/

#pragma mark - Memory Management

@synthesize redColor = _redColor;
@synthesize blueColor = _blueColor;
@synthesize greenColor = _greenColor;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        UIImage *image = [UIImage imageNamed:@"tab-bar-special"];
        UIImage *selected = [UIImage imageNamed:@"tab-bar-special-selected"];
        NSString *title = NSLocalizedString(@"Special",
                                            @"Title of tab bar with special features");
        self.tabBarItem = [[UITabBarItem alloc]
                           initWithTitle:title
                           image:image
                           selectedImage:selected];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Drag and Drop

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] == 1) {
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        for (UIImageView *box in self.view.subviews) {
            if ([box isMemberOfClass:[UIImageView class]]) {
                if (touchPoint.x > box.frame.origin.x &&
                    touchPoint.x < box.frame.origin.x + box.frame.size.width &&
                    touchPoint.y > box.frame.origin.y &&
                    touchPoint.y < box.frame.origin.y + box.frame.size.height) {
                    self.dragObject = box;
                    self.touchOffset = CGPointMake(touchPoint.x - box.frame.origin.x,
                                                   touchPoint.y - box.frame.origin.y);
                    self.homePosition = CGPointMake(box.frame.origin.x,
                                                    box.frame.origin.y);
                    [self.view bringSubviewToFront:self.dragObject];
                }
            }
        }
    }
}

- (BOOL)touchPointIsLeftWell:(CGPoint)touchPoint {
    return [self touchPoint:touchPoint isWithFrame:[self.leftDropTarget frame]];
}

- (BOOL)touchPointIsRightWell:(CGPoint)touchPoint {
    return [self touchPoint:touchPoint isWithFrame:[self.rightDropTarget frame]];
}

- (BOOL)touchPoint:(CGPoint)touchPoint isWithFrame:(CGRect)frame {
    return
    touchPoint.x > frame.origin.x &&
    touchPoint.x < frame.origin.x + frame.size.width &&
    touchPoint.y > frame.origin.y &&
    touchPoint.y < frame.origin.y + frame.size.height;
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    CGRect newDragObjectFrame = CGRectMake(touchPoint.x - self.touchOffset.x,
                                           touchPoint.y - self.touchOffset.y,
                                           self.dragObject.frame.size.width,
                                           self.dragObject.frame.size.height);
    self.dragObject.frame = newDragObjectFrame;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    UIView *targetWell = nil;
    if ([self touchPointIsLeftWell:touchPoint]) {
        targetWell = self.leftDropTarget;
    } else {
        targetWell = self.rightDropTarget;
    }

    if (targetWell) {
        UIColor *newColor = [self colorForImageView:self.dragObject];
        targetWell.backgroundColor = newColor;

        CGRect targetFrame = CGRectMake(self.homePosition.x, self.homePosition.y,
                                        self.dragObject.frame.size.width,
                                        self.dragObject.frame.size.height);

        __weak typeof(self) wself = self;
        [UIView animateWithDuration:0.4 animations:^{
            wself.dragObject.frame = targetFrame;
        }];
    }
}

#pragma mark - Colors

- (UIColor *)redColor {
    if (_redColor) { return _redColor; }
    _redColor = [UIColor colorWithRed:153/255.0
                                green:39/255.0
                                 blue:39/255.0
                                alpha:1.0];
    return _redColor;
}

- (UIColor *)blueColor {
    if (_blueColor) { return _blueColor; }
    _blueColor = [UIColor colorWithRed:29/255.0
                                 green:90/255.0
                                  blue:171/255.0
                                 alpha:1.0];
    return _blueColor;
}

- (UIColor *)greenColor {
    if (_greenColor) { return _greenColor; }
    _greenColor = [UIColor colorWithRed:33/255.0
                                  green:128/255.0
                                   blue:65/255.0
                                  alpha:1.0];
    return _greenColor;
}

- (UIColor *)colorForImageView:(UIImageView *)imageView {
    NSInteger tag = imageView.tag;
    switch (tag) {
        case kTagRedImageView: { return self.redColor; }
        case kTagBlueImageView: { return self.blueColor; }
        case kTagGreenImageView: { return self.greenColor; }
        default:
            return nil;
            break;
    }
}

#pragma mark - Orientation / Rotation

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL) shouldAutorotate {
    return YES;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.redImageView.tag = kTagRedImageView;

    self.blueImageView.tag = kTagBlueImageView;

    self.greenImageView.tag = kTagGreenImageView;
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

@end

#import "ScrollplicationsController.h"
#import "UIView+Positioning.h"

static NSString *const CBXUIScrollViewShouldCenterNotification =
@"sh.calaba.TestApp UIScrollView should center";

@interface UIScrollView (CalCentering)

- (void) centerContentToBounds;

@end

@implementation UIScrollView (CalCentering)

- (void) centerContentToBounds {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:CBXUIScrollViewShouldCenterNotification
     object:self];
}

@end

@interface ScrollplicationsController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *lightBlue;
@property (weak, nonatomic) IBOutlet UIView *purple;
@property (weak, nonatomic) IBOutlet UIView *darkBlue;

@property (weak, nonatomic) IBOutlet UIView *red;
@property (weak, nonatomic) IBOutlet UIView *cayene;
@property (weak, nonatomic) IBOutlet UIView *darkRed;

@property (weak, nonatomic) IBOutlet UIView *lightGray;
@property (weak, nonatomic) IBOutlet UIView *gray;
@property (weak, nonatomic) IBOutlet UIView *darkGray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

- (void) updateContentViewFrame;
- (void) centerScrollViewContent:(BOOL) animate;
- (void) handleScrollViewShouldCenterNotification:(NSNotification *) notification;

@end

@implementation ScrollplicationsController

#pragma mark - Memory Management

@synthesize scrollView = _scrollView;
@synthesize contentView = _contentView;

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Orientation / Rotation

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL) shouldAutorotate {
    return YES;
}

#pragma mark - View Lifecycle

- (void) updateContentViewFrame {
    NSLog(@"Updating content view frame");
    UIView *parentView = self.view;
    CGFloat max = MAX(parentView.width, parentView.height);
    self.contentViewHeight.constant = max * 2;
    self.contentViewWidth.constant = max * 2;

    UINavigationBar *navBar = self.navigationController.navigationBar;
    CGFloat topHeight = navBar.height;
    if (![[UIApplication sharedApplication] isStatusBarHidden]) {
        CGRect frame = [[UIApplication sharedApplication] statusBarFrame];
        topHeight = topHeight + frame.size.height;
    }
    UITabBar *tabBar = self.tabBarController.tabBar;
    CGFloat bottomHeight = tabBar.height;

    self.scrollView.contentInset = UIEdgeInsetsMake(topHeight, 0, bottomHeight, 0);
}

- (void) centerScrollViewContent:(BOOL) animate {

    UIScrollView *scrollView = self.scrollView;

    CGFloat x = (scrollView.contentSize.width/2) - (scrollView.bounds.size.width/2);
    CGFloat y = (scrollView.contentSize.height/2) - (scrollView.bounds.size.height/2);

    [scrollView setContentOffset:CGPointMake(x, y) animated:animate];
}

- (void) handleScrollViewShouldCenterNotification:(NSNotification *) notification {
    [self centerScrollViewContent:YES];
}

- (void) buttonTouchedBack:(id) sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(handleScrollViewShouldCenterNotification:)
     name:CBXUIScrollViewShouldCenterNotification
     object:nil];
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self updateContentViewFrame];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self updateContentViewFrame];
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

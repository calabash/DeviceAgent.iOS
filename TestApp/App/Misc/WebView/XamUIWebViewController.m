#import "XamUIWebViewController.h"

typedef enum : NSUInteger {
    kTagView = 0,
    kTagWebView
} view_tags;

@interface XamUIWebViewController ()

@property(strong, nonatomic, readonly) UIWebView *webView;

@end

@implementation XamUIWebViewController

#pragma mark - Memory Management

@synthesize webView = _webView;

- (instancetype) init {
    self = [super init];
    if (self){
        UIImage *image = [UIImage imageNamed:@"UIWebViewTab"];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"UIWebView"
                                                        image:image
                                                          tag:0];
    }
    return self;
}

#pragma mark - Lazy Evaled Ivars

- (UIWebView *) webView {
    if (_webView) { return _webView; }
    CGRect frame = CGRectMake(0, 20,
                              self.view.bounds.size.width,
                              self.view.bounds.size.height - 20);
    _webView = [[UIWebView alloc] initWithFrame:frame];
    _webView.tag = kTagWebView;
    _webView.accessibilityIdentifier = @"landing page";
    _webView.accessibilityLabel = @"Zielseite";
    return _webView;
}

#pragma mark - View Lifecycle

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) loadView {
    CGRect frame = [[UIScreen mainScreen] bounds];
    UIView *view = [[UIView alloc] initWithFrame:frame];

    view.tag = kTagView;
    view.accessibilityIdentifier = @"root";

    view.backgroundColor = [UIColor whiteColor];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view = view;
    self.title = @"UIWebView";
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

    if (![self.view viewWithTag:kTagWebView]) {
        UIWebView *webView = self.webView;
        [self.view addSubview:webView];

        NSString *page = @"https://calabash-ci.macminicolo.net/CalWebViewApp/page.html";
        NSURL *url = [NSURL URLWithString:page];

        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

@end

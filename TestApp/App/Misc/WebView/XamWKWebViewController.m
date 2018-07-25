
#import "XamWKWebViewController.h"
#import "UIWebView+FLUIWebView.h"
#import "WKWebView+FLWKWebView.h"
#import "objc/runtime.h"
#import "CBXURLHelper.h"

typedef enum : NSUInteger {
    kTagView = 0,
    kTagWebView
} view_tags;

@interface XamWKWebViewController ()

@property (strong, nonatomic, readonly) UIView <FLWebViewProvider> *webView;

@end

@implementation XamWKWebViewController

#pragma mark - Memory Management

@synthesize webView = _webView;

#pragma mark - UIWebView Delegate Methods

/*
 Called on iOS devices that do not have WKWebView when the UIWebView requests
 to start loading a URL request.  Note that it just calls
 shouldStartDecidePolicy, which is a shared delegate method.  Returning YES here
 would allow the request to complete, returning NO would stop it.
 */
- (BOOL) webView: (UIWebView *) webView shouldStartLoadWithRequest: (NSURLRequest *) request
  navigationType: (UIWebViewNavigationType) navigationType {
    return [self shouldStartDecidePolicy: request];
}

/*
 Called on iOS devices that do not have WKWebView when the UIWebView starts
 loading a URL request. Note that it just calls didStartNavigation, which is a
 shared delegate method.
 */
- (void) webViewDidStartLoad: (UIWebView *) webView {
    [self didStartNavigation];
}

/*
 Called on iOS devices that do not have WKWebView when a URL request load failed.
 Note that it just calls failLoadOrNavigation, which is a shared delegate method.
 */
- (void) webView: (UIWebView *) webView didFailLoadWithError: (NSError *) error {
    [self failLoadOrNavigation: [webView request] withError: error];
}

/*
 Called on iOS devices that do not have WKWebView when the UIWebView finishes
 loading a URL request. Note that it just calls finishLoadOrNavigation, which is
 a shared delegate method.
 */
- (void) webViewDidFinishLoad: (UIWebView *) webView {
    [self finishLoadOrNavigation: [webView request]];
}

#pragma mark - WKWebView Delegate Methods

/*
 Called on iOS devices that have WKWebView when the web view wants to start
 navigation. Note that it calls shouldStartDecidePolicy, which is a shared
 delegate method, but it's essentially passing the result of that method into
 decisionHandler, which is a block.
 */
- (void) webView: (WKWebView *) webView decidePolicyForNavigationAction: (WKNavigationAction *) navigationAction
 decisionHandler: (void (^)(WKNavigationActionPolicy)) decisionHandler {
    decisionHandler([self shouldStartDecidePolicy: [navigationAction request]]);
}

/*
 Called on iOS devices that have WKWebView when the web view starts loading a
 URL request. Note that it just calls didStartNavigation, which is a shared
 delegate method.
 */
- (void) webView: (WKWebView *) webView didStartProvisionalNavigation: (WKNavigation *) navigation {
    [self didStartNavigation];
}

/*
 Called on iOS devices that have WKWebView when the web view fails to load a
 URL request.  Note that it just calls failLoadOrNavigation, which is a shared
 delegate method, but it has to retrieve the active request from the web view as
 WKNavigation doesn't contain a reference to it.
 */
- (void) webView:(WKWebView *) webView didFailProvisionalNavigation: (WKNavigation *) navigation
       withError: (NSError *) error {
    [self failLoadOrNavigation: [webView request] withError: error];
}

/*
 Called on iOS devices that have WKWebView when the web view begins loading a
 URL request. This could call some sort of shared delegate method, but is unused
 currently.
 */
- (void) webView: (WKWebView *) webView didCommitNavigation: (WKNavigation *) navigation {
    // do nothing
}

/*
 Called on iOS devices that have WKWebView when the web view fails to load a URL
 request. Note that it just calls failLoadOrNavigation, which is a shared
 delegate method.
 */
- (void) webView: (WKWebView *) webView didFailNavigation: (WKNavigation *) navigation
       withError: (NSError *) error {
    [self failLoadOrNavigation: [webView request] withError: error];
}

/*
 Called on iOS devices that have WKWebView when the web view finishes loading a
 URL request. Note that it just calls finishLoadOrNavigation, which is a shared
 delegate method.
 */
- (void) webView: (WKWebView *) webView didFinishNavigation: (WKNavigation *) navigation {
    [self finishLoadOrNavigation: [webView request]];
}

#pragma mark - Shared Delegate Methods

/*
 This is called whenever the web view wants to navigate.
 */
- (BOOL) shouldStartDecidePolicy: (NSURLRequest *) request {
    // Determine whether or not navigation should be allowed.
    // Return YES if it should, NO if not.

    return YES;
}

/*
 This is called whenever the web view has started navigating.
 */
- (void) didStartNavigation {
    // Update things like loading indicators here.
}

/*
 This is called when navigation failed.
 */
- (void) failLoadOrNavigation: (NSURLRequest *) request withError: (NSError *) error {
    // Notify the user that navigation failed, provide information on the error, and so on.
}

/*
 This is called when navigation succeeds and is complete.
 */
- (void) finishLoadOrNavigation: (NSURLRequest *) request {
    // Remove the loading indicator, maybe update the navigation bar's title if you have one.
}

#pragma mark - Lazy Evaled Ivars

- (UIView<FLWebViewProvider> *) webView {
    if (_webView) { return _webView; }

    CGRect frame = CGRectMake(0, 20,
                              self.view.bounds.size.width,
                              self.view.bounds.size.height - 20);
    if(objc_getClass("WKWebView")) {
        _webView = [[WKWebView alloc] initWithFrame:frame];
    } else {
        _webView = [[UIWebView alloc] initWithFrame:frame];
    }

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


    NSString *navTitle;
    if(objc_getClass("WKWebView")) {
        navTitle = @"WKWebView";
    } else {
        navTitle = @"UIWebView";
    }
    self.title = navTitle;
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
        UIView<FLWebViewProvider> *webView = self.webView;
        [self.view addSubview:webView];
        NSURL *url = [CBXURLHelper URLForTestPage];
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

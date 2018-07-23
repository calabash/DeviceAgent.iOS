
#import "SafariController.h"
#import "CBXURLHelper.h"
#import <SafariServices/SafariServices.h>

@interface SafariController () <SFSafariViewControllerDelegate>

@end

@implementation SafariController

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SFSafariViewControllerDelegate

- (void)safariViewController:(SFSafariViewController *)controller
      didCompleteInitialLoad:(BOOL)didLoadSuccessfully {
    NSLog(@"SafariViewController did complete initial load");
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {

}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *url = [CBXURLHelper URLForTestPage];
    SFSafariViewController *controller;

#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        SFSafariViewControllerConfiguration *config = [SFSafariViewControllerConfiguration new];
        controller = [[SFSafariViewController alloc]
                      initWithURL:url
                      configuration:config];
    } else {
        controller = [[SFSafariViewController alloc]
                      initWithURL:url entersReaderIfAvailable:NO];
    }
#else
    controller = [[SFSafariViewController alloc]
                  initWithURL:url entersReaderIfAvailable:NO];
#endif

    controller.delegate = self;

    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow makeKeyWindow];
    UIViewController *root = [keyWindow rootViewController];
    [root presentViewController:controller
     animated:NO
     completion:^{
         NSLog(@"Presenting SafariViewController");
     }];
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

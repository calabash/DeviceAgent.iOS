
#import "SafariController.h"
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

    NSString *page = @"https://calabash-ci.macminicolo.net/CalWebViewApp/page.html";
    NSURL *url = [NSURL URLWithString:page];
    SFSafariViewController *controller;
    controller = [[SFSafariViewController alloc]
                  initWithURL:url
                  entersReaderIfAvailable:YES];
    controller.delegate = self;
    [self presentViewController:controller
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

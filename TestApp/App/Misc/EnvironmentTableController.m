
#import "EnvironmentTableController.h"

@interface EnvironmentTableController ()

@property (copy, readonly) NSDictionary<NSString *, NSString *> *environment;

@end

@implementation EnvironmentTableController

@synthesize environment = _environment;

- (NSDictionary<NSString *, NSString *> *)environment {
    if (_environment) { return _environment; }

    NSDictionary *processEnv = NSProcessInfo.processInfo.environment;

    _environment = [NSDictionary dictionaryWithDictionary:processEnv];

    return _environment;
}

- (NSString *)keyForIndexPath:(NSIndexPath *)indexPath {
    SEL selector = @selector(caseInsensitiveCompare:);
    NSArray *sorted = [self.environment.allKeys sortedArrayUsingSelector:selector];
    return sorted[indexPath.row];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger) tableView:(UITableView *) tableView
  numberOfRowsInSection:(NSInteger) aSection {
    return self.environment.count;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"
                                           forIndexPath:indexPath];

    NSString *title = [self keyForIndexPath:indexPath];
    NSString *details = self.environment[title];

    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:3030];
    titleLabel.text = title;

    UILabel *detailsLabel = (UILabel *)[cell.contentView viewWithTag:3031];
    detailsLabel.text = details;

    NSString *rowIdentifier = [NSString stringWithFormat:@"%@ row",
                                        [title lowercaseString]];
    cell.accessibilityIdentifier = rowIdentifier;
    titleLabel.accessibilityIdentifier = [rowIdentifier stringByAppendingString:@" title"];
    detailsLabel.accessibilityIdentifier = [rowIdentifier stringByAppendingString:@" details"];

    return cell;
}

- (BOOL)    tableView:(UITableView *) tableView
canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return NO;
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

    // tapping the status bar scrolls to the top
    self.tableView.scrollsToTop = YES;
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _environment = nil;
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

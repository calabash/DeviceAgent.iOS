
#import "ArgumentsTableController.h"

@interface ArgumentsTableController ()

@property (copy, readonly) NSDictionary<NSString *, NSString *> *arguments;

@end

@implementation ArgumentsTableController

@synthesize arguments = _arguments;

- (NSDictionary<NSString *, NSString *> *)arguments {
    if (_arguments) { return _arguments; }

    NSArray <NSString *> *processArgs = NSProcessInfo.processInfo.arguments;
    NSMutableDictionary <NSString *, NSString *> *mutable;
    mutable = [NSMutableDictionary dictionaryWithCapacity:[processArgs count]];

    for (NSString *arg in processArgs) {
       NSArray *tokens = [arg componentsSeparatedByString:@"="];
        if (tokens.count == 1) {
            [mutable setObject:@"< variable defined >"
                        forKey:tokens[0]];
        } else if (tokens.count == 2) {
            [mutable setObject:tokens[1]
                        forKey:tokens[0]];
        } else {
          [mutable setObject:@"< multiple = signs >"
                      forKey:tokens[0]];
        }
    }

    _arguments = [NSDictionary dictionaryWithDictionary:mutable];
    return _arguments;
}

- (NSString *)keyForIndexPath:(NSIndexPath *)indexPath {
    SEL selector = @selector(caseInsensitiveCompare:);
    NSArray *sorted = [self.arguments.allKeys sortedArrayUsingSelector:selector];
    return sorted[indexPath.row];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger) tableView:(UITableView *) tableView
  numberOfRowsInSection:(NSInteger) aSection {
    return self.arguments.count;
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
    NSString *details = self.arguments[title];

    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:3030];
    titleLabel.text = title;

    UILabel *detailsLabel = (UILabel *)[cell.contentView viewWithTag:3031];
    detailsLabel.text = details;

    cell.accessibilityIdentifier = [NSString stringWithFormat:@"%@ row",
                                    [title lowercaseString]];

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
    _arguments = nil;
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

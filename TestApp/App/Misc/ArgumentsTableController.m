
#import "ArgumentsTableController.h"

@interface ArgumentsTableController ()

@property (copy, readonly) NSArray<NSString *> *arguments;
@property (strong, readonly) NSDictionary<NSString *, NSString *> *rowDetails;

@end

@implementation ArgumentsTableController

@synthesize arguments = _arguments;
@synthesize rowDetails = _rowDetails;


- (NSArray<NSString *> *)arguments {
    if (_arguments) { return _arguments; }

    NSArray <NSString *> *processArgs = NSProcessInfo.processInfo.arguments;
    _arguments = [NSArray arrayWithArray:processArgs];
    return _arguments;
}

- (NSDictionary <NSString *, NSString *> *)rowDetails {
   if (_rowDetails) { return _rowDetails; }

    NSMutableArray *arguments = [self.arguments mutableCopy];
    NSMutableDictionary <NSString *, NSString *> *mutable;
    mutable = [NSMutableDictionary dictionaryWithCapacity:[arguments count]];

    NSUInteger index;
    index = [arguments indexOfObject:@"CALABUS_DRIVER"];

    if (index != NSNotFound) {
        [mutable setObject:@"CALABUS_DRIVER is in the arguments"
                    forKey:@"The Calabus Driver is on the job!"];
        [arguments removeObjectAtIndex:index];
    } else {
        [mutable setObject:@"CALABUS_DRIVER is not in the arguments"
                    forKey:@"The Calabus Driver is no where to be found!"];
    }

    index = [arguments indexOfObject:@"-AppleLanguages"];
    if (index != NSNotFound) {
        NSUInteger valueIndex = index + 1;
        if (valueIndex < [arguments count]) {
            NSString *value = arguments[valueIndex];
            [mutable setObject:[NSString stringWithFormat:@"\"-AppleLanguages\", \"%@\"",
                                                          value]
                        forKey:[NSString stringWithFormat:@"Language precedence: %@",
                                                          value]];
            [arguments removeObjectAtIndex:valueIndex];
            [arguments removeObjectAtIndex:index];
        } else {
            [mutable setObject:@"Value missing for key: -AppleLanguages"
                        forKey:@"-AppleLanguages ???"];
            [arguments removeObjectAtIndex:index];
        }
    } else {
        [mutable setObject:@"-AppleLanguages key/value pair is not in the arguments"
                    forKey:@"Language precedence is not set"];
    }

    index = [arguments indexOfObject:@"-AppleLocale"];
    if (index != NSNotFound) {
        NSUInteger valueIndex = index + 1;
        if (valueIndex < [arguments count]) {
            NSString *value = arguments[valueIndex];
            [mutable setObject:[NSString stringWithFormat:@"\"-AppleLocale\", \"%@\"",
                                                          value]
                        forKey:[NSString stringWithFormat:@"Preferred locale: %@",
                                                          value]];

            [arguments removeObjectAtIndex:valueIndex];
            [arguments removeObjectAtIndex:index];
        } else {
            [mutable setObject:@"Value missing for key: -AppleLocale"
                        forKey:@"-AppleLocale ???"];
            [arguments removeObjectAtIndex:index];
        }
    } else {
        [mutable setObject:@"-AppleLocale key/value pair is not in the arguments"
                    forKey:@"Preferred locale is not set"];
    }

    for (NSString *argument in arguments) {
        [mutable setObject:@"< Argument >"
                    forKey:argument];
    }

    _rowDetails = [NSDictionary dictionaryWithDictionary:mutable];
    return _rowDetails;
}

- (NSString *)keyForIndexPath:(NSIndexPath *)indexPath {
    SEL selector = @selector(caseInsensitiveCompare:);
    NSArray *sorted = [self.rowDetails.allKeys sortedArrayUsingSelector:selector];
    return sorted[indexPath.row];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger) tableView:(UITableView *) tableView
  numberOfRowsInSection:(NSInteger) aSection {
    return self.rowDetails.count;
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
    NSString *details = self.rowDetails[title];

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

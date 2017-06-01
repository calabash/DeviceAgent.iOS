
#import "CompanyTableController.h"
#import <objc/runtime.h>

/**
 Calabash needs to test that its clear text route calls the UISearchBarDelegate
 selectors in the correct order.

 Calabash can call arbitrary selectors on Objective-C views.

 This category adds an associative object to UITableView.  The object is an
 array onto which we push delegate methods as they are called.

 After the clear text route is called, Calabash can ask for list of the
 selectors that were called and with what arguements.

 # Get a list of selectors + arguments
 query("UITableView index:0", :searchBarDelegateMethodCalls)

 # Clear the list of selectors + arguments
 query("UITableView index:0", :clearSearchBarDelegateMethodCalls)

 NSHipster has a good associated object reference:
 http://nshipster.com/associated-objects/
 */
@interface UITableView (TestAppAdditions)

- (void)clearSearchBarDelegateMethodCalls;
- (NSString *)JSONSearchBarDelegateMethodCalls;

@property (nonatomic, strong) NSMutableArray *searchBarDelegateMethodCalls;

@end

@implementation UITableView (TestAppAdditions)

@dynamic searchBarDelegateMethodCalls;

- (void)setSearchBarDelegateMethodCalls:(id)object {
    // The second arg is a key; it could be any const.  Using a selector as a
    // key is a convenience.
    objc_setAssociatedObject(self, @selector(searchBarDelegateMethodCalls),
                             object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)searchBarDelegateMethodCalls {
    // The second arg is a key; it could be any const.  Using a selector as a
    // key is a convenience.
    return (NSMutableArray *)objc_getAssociatedObject(self,
                                                      @selector(searchBarDelegateMethodCalls));
}

- (NSString *)JSONSearchBarDelegateMethodCalls {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.searchBarDelegateMethodCalls
                                                       options:0
                                                         error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (void)clearSearchBarDelegateMethodCalls {
    [[self searchBarDelegateMethodCalls] removeAllObjects];
    [self setSearchBarDelegateMethodCalls:[NSMutableArray arrayWithCapacity:10]];
}

@end

@interface CompanyTableController ()
<UITableViewDelegate,
UITableViewDataSource,
UISearchControllerDelegate,
UISearchBarDelegate,
UISearchResultsUpdating,
UISearchBarDelegate>

@property(strong, nonatomic, readonly) NSArray *logoNames;
@property(strong, nonatomic, readonly) NSMutableArray *logoImages;
@property(strong, nonatomic, readonly) NSMutableArray *companyNames;
@property(strong, nonatomic, readonly) UISearchController *searchController;
@property(copy, nonatomic, readonly) NSArray *searchResults;

@end

@implementation CompanyTableController

@synthesize logoNames = _logoNames;
@synthesize logoImages = _logoImages;
@synthesize companyNames = _companyNames;
@synthesize searchController = _searchController;
@synthesize searchResults = _searchResults;

- (NSArray *) logoNames {
    if (_logoNames) { return _logoNames; }

    _logoNames =
    @[
      @"amazon",
      @"apple",
      @"basecamp",
      @"android",
      @"blogger",
      @"digg",
      @"dropbox",
      @"evernote",
      @"facebook",
      @"fancy",
      @"flickr",
      @"foursquare",
      @"github",
      @"google-plus",
      @"google",
      @"icloud",
      @"instagram",
      @"linkedin",
      @"paypal",
      @"pinterest",
      @"quora",
      @"rdio",
      @"reddit",
      @"skype",
      @"spotify",
      @"steam",
      @"twitter",
      @"windows",
      @"wordpress",
      @"youtube"
      ];

    return _logoNames;
}

- (NSMutableArray *)logoImages {
    if (_logoImages) { return _logoImages; }

    _logoImages = [[NSMutableArray alloc] initWithCapacity:[self.logoNames count]];

    for (NSString *name in self.logoNames) {
        NSString *imageName = [NSString stringWithFormat:@"logo-%@", name];
        UIImage *image = [UIImage imageNamed:imageName];
        [_logoImages addObject:image];
    }
    return _logoImages;
}

- (NSMutableArray *)companyNames {
    if (_companyNames) { return _companyNames; }

    _companyNames = [[NSMutableArray alloc] initWithCapacity:[self.logoNames count]];

    for (NSString *name in self.logoNames) {
        NSString *companyName = nil;
        if ([name isEqualToString:@"google-plus"]) {
            companyName = @"Google +";
        } else if ([name isEqualToString:@"icloud"]) {
            companyName = @"iCloud";
        } else if ([name isEqualToString:@"youtube"]) {
            companyName = @"YouTube";
        } else {
            companyName = [name capitalizedString];
        }

        [_companyNames addObject:[companyName copy]];
    }
    return _companyNames;
}

- (UISearchController *)searchController {
    if (_searchController) { return _searchController; }
    _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.searchBar.delegate = self;
    [_searchController.searchBar sizeToFit];
    return _searchController;
}

- (NSArray *)searchResults {
    NSString *searchString = self.searchController.searchBar.text;
    if (searchString.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@",
                                  searchString];
        return [self.companyNames filteredArrayUsingPredicate:predicate];
    } else {
        return self.companyNames;
    }
}

#pragma mark - <UITableViewDataSource>

- (NSInteger) tableView:(UITableView *) tableView
  numberOfRowsInSection:(NSInteger) aSection {
    if (self.searchController.isActive && self.searchController.searchBar.text.length > 0) {
        return self.searchResults.count;
    } else {
        return self.companyNames.count;
    }
    return 0;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"
                                           forIndexPath:indexPath];

    NSString *name;
    if (self.searchController.isActive &&
        (![self.searchController.searchBar.text isEqualToString:@""])) {
        name = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        name = self.companyNames[(NSUInteger)indexPath.row];
    }

    UILabel *label = (UILabel *)[cell.contentView viewWithTag:3030];
    label.text = name;

    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:3031];
    imageView.image = self.logoImages[(NSUInteger)indexPath.row];

    cell.accessibilityIdentifier = [NSString stringWithFormat:@"%@ row",
                                                              [name lowercaseString]];

    return cell;
}

- (BOOL)    tableView:(UITableView *) tableView
canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return YES;
}

- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.logoImages removeObjectAtIndex:(NSUInteger)indexPath.row];
        [self.companyNames removeObjectAtIndex:(NSUInteger)indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        NSLog(@"Unhandled editing style! %@", @(editingStyle));
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void) tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = self.logoImages[(NSUInteger)sourceIndexPath.row];
    NSString *name = self.companyNames[(NSUInteger)sourceIndexPath.row];

    [self.logoImages removeObjectAtIndex:(NSUInteger)sourceIndexPath.row];
    [self.companyNames removeObjectAtIndex:(NSUInteger)sourceIndexPath.row];

    [self.logoImages insertObject:image
                          atIndex:(NSUInteger)destinationIndexPath.row];
    [self.companyNames insertObject:name
                            atIndex:(NSUInteger)destinationIndexPath.row];
}

#pragma mark - UISearchControllerDelegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"UISearchBarDelegate: searchBar:textDidChange:");
    NSArray *call = @[@"searchBar:textDidChange:", @[@"#<UISearchBar>", searchText]];
    [[self.tableView searchBarDelegateMethodCalls] addObject:call];
}

- (BOOL)      searchBar:(UISearchBar *)searchBar
shouldChangeTextInRange:(NSRange)range
        replacementText:(NSString *)text {
    NSLog(@"UISearchBarDelegate: searchBar:shouldChangeTextInRange:replacementText:");
    NSArray *call = @[@"searchBar:shouldChangeTextInRange:replacementText:",
                      @[@"#<UISearchBar>", NSStringFromRange(range), text]];
    [[self.tableView searchBarDelegateMethodCalls] addObject:call];
    return YES;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"UISearchBarDelegate: searchBarShouldBeginEditing:");
    NSArray *call = @[@"searchBarShouldBeginEditing:", @[@"#<UISearchBar>"]];
    [[self.tableView searchBarDelegateMethodCalls] addObject:call];
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"UISearchBarDelegate: searchBarTextDidBeginEditing:");
    NSArray *call = @[@"searchBarTextDidBeginEditing:", @[@"#<UISearchBar>"]];
    [[self.tableView searchBarDelegateMethodCalls] addObject:call];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    NSLog(@"UISearchBarDelegate: searchBarShouldEndEditing:");
    NSArray *call = @[@"searchBarShouldEndEditing:", @[@"#<UISearchBar>"]];
    [[self.tableView searchBarDelegateMethodCalls] addObject:call];
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"UISearchBarDelegate: searchBarTextDidEndEditing:");
    NSArray *call = @[@"searchBarTextDidEndEditing:", @[@"#<UISearchBar>"]];
    [[self.tableView searchBarDelegateMethodCalls] addObject:call];
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
    self.view.accessibilityIdentifier = @"table page";

    self.navigationItem.rightBarButtonItem = self.editButtonItem;

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
    _logoImages = nil;
    _companyNames = nil;
    [self.tableView reloadData];

    if (!_searchController.searchBar.superview) {
        self.tableView.tableHeaderView = self.searchController.searchBar;
    }

    [self.tableView clearSearchBarDelegateMethodCalls];
    NSLog(@"%@", [self.tableView searchBarDelegateMethodCalls]);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (self.searchController.isActive) {
        self.searchController.active = NO;
    }
    NSLog(@"%@", [self.tableView searchBarDelegateMethodCalls]);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

@end

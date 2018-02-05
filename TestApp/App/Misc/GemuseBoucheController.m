
#import "GemuseBoucheController.h"
#import <objc/runtime.h>


@interface GemuseBoucheController ()

@property (strong, readonly) NSDictionary<NSString *, NSString *> *rowDetails;

@end

@implementation GemuseBoucheController

@synthesize rowDetails = _rowDetails;

- (Class)classForName:(NSString *)name {
    return objc_getClass([name cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (BOOL)classAvailable:(NSString *)name {
    return !![self classForName:name];
}

- (NSString *)nameForGemuseFamily:(NSString *)name {
    Class klass = NSClassFromString(name);
    SEL selector = NSSelectorFromString(@"familyName");

    NSMethodSignature *signature;
    signature = [klass methodSignatureForSelector:selector];
    NSInvocation *invocation;

    invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = klass;
    invocation.selector = selector;

    NSString *familyName = nil;
    void *buffer;
    [invocation invoke];
    [invocation getReturnValue:&buffer];
    familyName = (__bridge NSString *)buffer;

    return familyName;
}

- (NSArray *)vegetablesInFamily:(NSString *)name {
    Class klass = NSClassFromString(name);
    SEL selector = NSSelectorFromString(@"vegetables");

    NSMethodSignature *signature;
    signature = [klass methodSignatureForSelector:selector];
    NSInvocation *invocation;

    invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = klass;
    invocation.selector = selector;

    NSArray *array = nil;
    void *buffer;
    [invocation invoke];
    [invocation getReturnValue:&buffer];
    array = (__bridge NSArray *)buffer;

    return array;
}

- (NSDictionary <NSString *, NSString *> *)rowDetails {
    if (_rowDetails) { return _rowDetails; }

    NSMutableDictionary <NSString *, NSString *>*mutable;
    mutable = [NSMutableDictionary dictionaryWithCapacity:3];

    for (NSString *className in @[@"CBXBetaVulgaris", @"CBXBrassica", @"CBXCurcubits"]) {
        if ([self classAvailable:className]) {
            NSString *key = [self nameForGemuseFamily:className];
            NSArray *array = [self vegetablesInFamily:className];
            mutable[key] = [array componentsJoinedByString:@","];
        }
    }

    if ([mutable count] == 0) {
        mutable[@"I am not Gemüsed"] = @"The GemüseBouche dylibs did not load";
    }

    if ([self classAvailable:@"EntitlementInjector"]) {
        mutable[@"Tomato: promoted to vegetable"] = @"EntitlementInjector.dylib was loaded";
    } else {
        mutable[@"Tomato: still a fruit"] = @"EntitlementInjector.dylib was not loaded";
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

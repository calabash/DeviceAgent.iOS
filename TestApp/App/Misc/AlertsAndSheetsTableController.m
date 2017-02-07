
#import "AlertsAndSheetsTableController.h"
#import <objc/runtime.h>
#import <Contacts/Contacts.h>
@import EventKit;

typedef enum : NSInteger {
    kRowContacts = 0,
    kRowCalendars,
    kRowReminders,
    kNumberOfRows
} TableRows;

@interface AlertsAndSheetsTableController ()

@property(nonatomic, copy, readonly) NSArray<NSDictionary *> *rowDetails;

@end

@implementation AlertsAndSheetsTableController

@synthesize rowDetails = _rowDetails;

- (void)rowTouchedContacts {
    NSLog(@"Contacts requested");
    [[[CNContactStore alloc] init] requestAccessForEntityType:CNEntityTypeContacts
                                            completionHandler:^(BOOL granted,
                                                                NSError * _Nullable error) {
                                            }];
}

- (void)rowTouchedCalendar {
    NSLog(@"Calendar requested");

    EKEventStore *eventStore = [[EKEventStore alloc] init];

    [eventStore requestAccessToEntityType:EKEntityTypeEvent
                               completion:^(BOOL granted, NSError *error) {

                               }];
}

- (void)rowTouchedReminders {
    NSLog(@"Reminders requested");

    EKEventStore *eventStore = [[EKEventStore alloc] init];

    [eventStore requestAccessToEntityType:EKEntityTypeReminder
                               completion:^(BOOL granted, NSError *error) {

                               }];
}

- (NSArray<NSDictionary *> *)rowDetails {
    if (_rowDetails && [_rowDetails count] == kNumberOfRows) { return _rowDetails; }

    NSMutableArray *mutable = [NSMutableArray arrayWithCapacity:kNumberOfRows];
    mutable[0] = @{@"title" : @"Contacts", @"selector" : @"rowTouchedContacts"};
    mutable[1] = @{@"title" : @"Calendar", @"selector" : @"rowTouchedCalendar"};
    mutable[2] = @{@"title" : @"Reminders", @"selector" : @"rowTouchedReminders"};

    _rowDetails = [NSArray arrayWithArray:mutable];
    return _rowDetails;
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
    NSDictionary *details = self.rowDetails[indexPath.row];
    NSString *title = details[@"title"];

    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:3030];
    titleLabel.text = title;

    cell.accessibilityIdentifier = [NSString stringWithFormat:@"%@ row",
                                    [title lowercaseString]];

    return cell;
}

- (BOOL)    tableView:(UITableView *) tableView
canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
    return 44;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    NSDictionary *details = self.rowDetails[indexPath.row];
    SEL selector = NSSelectorFromString(details[@"selector"]);

    NSMethodSignature *signature;
    signature = [[self class] instanceMethodSignatureForSelector:selector];

    NSInvocation *invocation;
    invocation = [NSInvocation invocationWithMethodSignature:signature];

    invocation.target = self;
    invocation.selector = selector;

    [invocation invoke];

    double delayInSeconds = 0.4;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
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

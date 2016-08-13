#import "CompanyTableController.h"

@interface CompanyTableController ()

@property(strong, nonatomic, readonly) NSArray *logoNames;
@property(strong, nonatomic, readonly) NSMutableArray *logoImages;
@property(strong, nonatomic, readonly) NSMutableArray *companyNames;

@end

@implementation CompanyTableController

@synthesize logoNames = _logoNames;
@synthesize logoImages = _logoImages;
@synthesize companyNames = _companyNames;

- (NSArray *) logoNames {
    if (_logoNames) { return _logoNames; }

    _logoNames =
    @[
      @"amazon",
      @"android",
      @"apple",
      @"basecamp",
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
    return _logoImages;
}

- (NSMutableArray *)companyNames {
    if (_companyNames) { return _companyNames; }

    _companyNames = [[NSMutableArray alloc] initWithCapacity:[self.logoNames count]];
    return _companyNames;
}

- (UIImage *)imageForRowAtIndexPath:(NSIndexPath *)path {
    NSUInteger row = path.row;
    if (row >= self.logoImages.count) {
        NSString *logoName = self.logoNames[row];
        NSString *imageName = [NSString stringWithFormat:@"logo-%@", logoName];
        UIImage *image = [UIImage imageNamed:imageName];
        self.logoImages[row] = image;
    }
    return self.logoImages[row];
}

- (NSString *)nameForRowAtIndexPath:(NSIndexPath *)path {
    NSUInteger row = path.row;
    if (row >= self.companyNames.count) {
        NSString *logoName = self.logoNames[row];
        NSString *companyName = [logoName copy];
        
        if ([companyName isEqualToString:@"google-plus"]) {
            companyName = @"Google +";
        } else if ([companyName isEqualToString:@"icloud"]) {
            companyName = @"iCloud";
        } else {
            companyName = [companyName capitalizedString];
        }
        
        self.companyNames[row] =  companyName;
    }
    
    return self.companyNames[row];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger) tableView:(UITableView *) tableView
  numberOfRowsInSection:(NSInteger) aSection {
    return [self.logoNames count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"
                                           forIndexPath:indexPath];
    NSString *name = [self nameForRowAtIndexPath:indexPath];

    UILabel *label = (UILabel *)[cell.contentView viewWithTag:3030];
    label.text = name;

    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:3031];
    imageView.image = [self imageForRowAtIndexPath:indexPath];

    cell.accessibilityIdentifier = [NSString stringWithFormat:@"%@ row",
                                    [name lowercaseString]];

    return cell;
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

#import <XCTest/XCTest.h>

@interface UITest : XCTestCase

@property(strong) XCUIApplication *aut;

@end

@implementation UITest

- (void)setUp {
    [super setUp];

    self.continueAfterFailure = NO;
    self.aut = [[XCUIApplication alloc] init];
    [self.aut launch];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testRotate {
//    [XCUIDevice sharedDevice].orientation = UIInterfaceOrientationLandscapeLeft;
//    UIDeviceOrientation deviceOrientation = [XCUIDevice sharedDevice].orientation;
//    NSLog(@"device orientation = %@", @(deviceOrientation));
//
//    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
//    NSLog(@"interface orientation = %@", @(interfaceOrientation));
//
//    XCTAssertEqual([@(deviceOrientation) integerValue],
//                   [@(interfaceOrientation) integerValue]);
}


- (void)testSegmentedControl {
    [XCUIDevice sharedDevice].orientation = UIDeviceOrientationPortrait;
    [self.aut.segmentedControls[@"segmented"].buttons[@"Second"] tap];
}

- (void)testTextEntry {
    [XCUIDevice sharedDevice].orientation = UIDeviceOrientationPortrait;

    [self.aut.tabBars.buttons[@"Misc"] tap];
    [self.aut.tables[@"misc page"].cells[@"text input row"] tap];

    NSMutableArray *times = [NSMutableArray arrayWithCapacity:100];


    NSString *text = nil;
    for (NSUInteger try = 0; try < 100; try++) {
        // show the keyboard
        [self.aut.textFields[@"text field"] tap];

        text = [[NSProcessInfo processInfo] globallyUniqueString];

        CFTimeInterval startTime = CACurrentMediaTime();
        // type the text
        [self.aut.textFields[@"text field"] typeText:text];
        CFTimeInterval elapsed = CACurrentMediaTime() - startTime;
        [times addObject:@(elapsed)];

        // dismiss the keyboard
        [self.aut.buttons[@"Done"] tap];

        XCUIElement *element = self.aut.staticTexts[@"question"];
        NSString *actual = [element label];

        NSString *expected = [NSString stringWithFormat:@"Ça va? - %@", text];

        XCTAssertEqualObjects(actual, expected);

        // clear the text field
        [self.aut.buttons[@"clear text field button"] tap];
    }

    CFTimeInterval accumulator = 0.0;
    for (NSNumber *time in times) {
        accumulator = accumulator + [time doubleValue];
    }

    CFTimeInterval mean = accumulator/(times.count * 1.0);

    NSLog(@"mean = %@", @(mean));

    CGFloat charPerSecond = [text length]/mean;

    NSLog(@"char per second = %@", @(charPerSecond));
}

- (void)testLongTextEntry {
    [XCUIDevice sharedDevice].orientation = UIDeviceOrientationPortrait;

    [self.aut.tabBars.buttons[@"Misc"] tap];

    NSMutableArray *times = [NSMutableArray arrayWithCapacity:100];

    NSString *text = @"Grünliche Dämmerung, nach oben zu lichter, nach unten zu dunkler. "
    "Die Höhe ist von wogendem Gewässer erfüllt, das rastlos von rechts nach links zu "
    "strömt. Nach der Tiefe zu lösen die Fluten sich in einen immer feineren feuchten\n";



    for (NSUInteger try = 0; try < 100; try++) {
        [self.aut.tables[@"misc page"].cells[@"text input row"] tap];
        [self.aut.buttons[@"clear text view button"] tap];
        [self.aut.textViews[@"text view"] tap];
        CFTimeInterval startTime = CACurrentMediaTime();
        [self.aut.textViews[@"text view"] typeText:text];
        CFTimeInterval elapsed = CACurrentMediaTime() - startTime;
        [times addObject:@(elapsed)];

        // dismiss the keyboard
        [self.aut.buttons[@"dismiss text view keyboard"] tap];

        XCTAssertEqualObjects([self.aut.textViews[@"text view"] value], text);
        [self.aut.navigationBars[@"Misc Menu"].buttons[@"Misc Menu"] tap];
    }

    CFTimeInterval accumulator = 0.0;
    for (NSNumber *time in times) {
        accumulator = accumulator + [time doubleValue];
    }

    CFTimeInterval mean = accumulator/(times.count * 1.0);

    NSLog(@"mean = %@", @(mean));

    CGFloat charPerSecond = [text length]/mean;

    NSLog(@"char per second = %@", @(charPerSecond));
}

- (void)testDoubleTap {

    NSMutableArray *times = [NSMutableArray arrayWithCapacity:100];

    for (NSUInteger index = 0; index < 10; index++) {
        [self.aut.tabBars.buttons[@"Tao"] tap];

        XCUIElement *button = self.aut.buttons[@"two finger double tap"];
        CFTimeInterval startTime = CACurrentMediaTime();

        // Two finger tap touches the farthest possible touch points in the view.
        // Computed touch locations {81, 110} and {227, 110} for visible frame {{76, 80}, {156, 60}}
        [button tapWithNumberOfTaps:2 numberOfTouches:2];
        CFTimeInterval elapsed = CACurrentMediaTime() - startTime;
        [times addObject:@(elapsed)];

        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.1, false);

        XCUIElement *element = self.aut.otherElements[@"complex touches"];
        XCTAssertEqualObjects([element label], @"two-finger double tap");
        [element tap];
        XCTAssertEqualObjects([element label], @"CLEARED");

        [self.aut.tabBars.buttons[@"Misc"] tap];
    }

    CFTimeInterval min = CGFLOAT_MAX;
    CFTimeInterval max = CGFLOAT_MIN;
    CFTimeInterval accumulator = 0.0;
    for (NSNumber *time in times) {
        CFTimeInterval interval = [time doubleValue];
        min = MIN(min, interval);
        max = MAX(max, interval);
        accumulator = accumulator + [time doubleValue];
    }

    CFTimeInterval mean = accumulator/(times.count * 1.0);

    NSLog(@"mean = %@", @(mean));
    NSLog(@" max = %@", @(max));
    NSLog(@" min = %@", @(min));
}

@end

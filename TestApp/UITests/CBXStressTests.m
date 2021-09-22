
#import <XCTest/XCTest.h>
#import "Screenshotter.h"

@interface XCUIApplication (TEST)

- (UIInterfaceOrientation)interfaceOrientation;

@end

@interface CBXStressTests : XCTestCase

@property(strong) XCUIApplication *aut;

@end

@implementation CBXStressTests

#pragma mark - Rotate

- (NSString *)stringForDeviceOrientation:(UIDeviceOrientation)orientation {
    switch (orientation) {
        case UIDeviceOrientationUnknown: { return @"Unknown"; }
        case UIDeviceOrientationPortrait: { return @"Portrait"; }
        case UIDeviceOrientationPortraitUpsideDown: { return @"Upside Down"; }
        case UIDeviceOrientationLandscapeLeft: { return @"Landscape Left"; }
        case UIDeviceOrientationLandscapeRight: { return @"Landscape Right"; }
        case UIDeviceOrientationFaceUp: { return @"Face Up"; }
        case UIDeviceOrientationFaceDown: { return @"Face Down"; }
    }
}

- (NSString *)stringForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    switch (orientation) {
        case UIDeviceOrientationUnknown: { return @"Unknown"; }
        case UIDeviceOrientationPortrait: { return @"Portrait"; }
        case UIDeviceOrientationPortraitUpsideDown: { return @"Upside Down"; }
        case UIDeviceOrientationLandscapeLeft: { return @"Landscape Left"; }
        case UIDeviceOrientationLandscapeRight: { return @"Landscape Right"; }
    }
}

- (UIInterfaceOrientation)interfaceOrientionForDeviceOrientation:(UIDeviceOrientation)orientation {
    switch (orientation) {
        case UIDeviceOrientationPortrait: { return UIInterfaceOrientationPortrait; }
        case UIDeviceOrientationPortraitUpsideDown: { return UIInterfaceOrientationPortraitUpsideDown; }
        case UIDeviceOrientationLandscapeLeft: { return UIInterfaceOrientationLandscapeRight; }
        case UIDeviceOrientationLandscapeRight: { return UIInterfaceOrientationLandscapeLeft; }
        default: { return UIInterfaceOrientationUnknown; }
    }
}

- (XCUIApplication *)springBoard {
    return [[XCUIApplication alloc]
            initWithBundleIdentifier:@"com.apple.SpringBoard"];
}

- (NSDictionary *)springBoardOrientation {
    return [self interfaceOrientation:[self springBoard]];
}

- (NSDictionary *)autOrientation {
    return [self interfaceOrientation:self.aut];
}

- (NSDictionary *)interfaceOrientation:(XCUIApplication *)application {
    UIInterfaceOrientation orientation = [application interfaceOrientation];
    return @{@"enum" : @(orientation),
             @"string" : [self stringForInterfaceOrientation:orientation]};
}


- (NSDictionary *)deviceOrientation {
    UIDeviceOrientation orientation = [[XCUIDevice sharedDevice] orientation];
    return @{@"enum" : @(orientation),
             @"string" : [self stringForDeviceOrientation:orientation]};
}

- (void)rotateDeviceToOrientation:(UIDeviceOrientation)orientation {
    [[XCUIDevice sharedDevice] setOrientation:orientation];
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 2.0, false);
    [Screenshotter screenshotWithTitle:@"Did ask device to rotate to orientation: "
     "%@ (%@) - screenshot after 2 seconds",
     [self stringForDeviceOrientation:orientation], @(orientation)];

    UIInterfaceOrientation interfaceOrientation;
    interfaceOrientation = [self interfaceOrientionForDeviceOrientation:orientation];
    [self waitForSpringBoardToRotateTo:interfaceOrientation timeout:5];
}

- (void)waitForSpringBoardToRotateTo:(UIInterfaceOrientation)orientation
                             timeout:(NSTimeInterval)timeout {
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"interfaceOrientation == %d",
                 orientation];

    XCTestExpectation *expectation;
    expectation = [self expectationForPredicate:predicate
                            evaluatedWithObject:[self springBoard]
                                        handler:nil];

    XCTWaiterResult waitResult;
    waitResult = [XCTWaiter waitForExpectations:@[expectation] timeout:timeout];
    NSDictionary *deviceOrientation, *interfaceOrientation, *autOrientation;


    if (waitResult == XCTWaiterResultCompleted) {
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 2.0, false);

        deviceOrientation = [self deviceOrientation];

        NSLog(@"Device has orientation: %@ (%@)",
              deviceOrientation[@"string"], deviceOrientation[@"enum"]);

        interfaceOrientation = [self springBoardOrientation];
        NSLog(@"SpringBoard has orientation: %@ (%@)",
              interfaceOrientation[@"string"], interfaceOrientation[@"enum"]);

        autOrientation = [self autOrientation];
        NSLog(@"AUT has orientation: %@ (%@)",
              autOrientation[@"string"], autOrientation[@"enum"]);
    } else {
        interfaceOrientation = [self springBoardOrientation];
        deviceOrientation = [self deviceOrientation];
        autOrientation = [self autOrientation];

        XCTFail(@"Expected SpringBoard to rotate to orientation after %@ seconds.\n"
                "   Expected interface orientation: %@ (%@)\n"
                "      Found interface orientation: %@ (%@)\n"
                "\n"
                "Device has orientation: %@ (%@)"
                "AUT has orientation: %@ (%@)",
                @(timeout),
                [self stringForInterfaceOrientation:orientation], @(orientation),
                interfaceOrientation[@"string"], interfaceOrientation[@"enum"],
                deviceOrientation[@"string"], deviceOrientation[@"enum"],
                autOrientation[@"string"], autOrientation[@"enum"]);
    }
}

#pragma mark - Tests

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = NO;
    self.aut = [XCUIApplication new];
    [self.aut launch];
    [self rotateDeviceToOrientation:UIDeviceOrientationPortrait];
}

- (void)tearDown {
    [super tearDown];
    self.aut = nil;
}

- (void)testThatAlwaysPasses {
    XCTAssertTrue(YES);
}

/*
 These tests take a long time to run and we don't want to run them all the time.

 Until App Center can filter XCUITest, we will need to comment and uncomment
 whenever we want to run these tests.
 */

/*
 * Try to reproduce "Timed out waiting for key event" bug.
 */
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

        if (@available(iOS 15, *)) {
            // dismiss the keyboard
            [self.aut.buttons[@"done"] tap];
            XCUIElement *element = self.aut.buttons[@"question"];
            NSString *actual = [element label];

            NSString *expected = [NSString stringWithFormat:@"Ça va? - %@", text];

            XCTAssertEqualObjects(actual, expected);
        }
        else{
            // dismiss the keyboard
            [self.aut.buttons[@"Done"] tap];

            XCUIElement *element = self.aut.staticTexts[@"question"];
            NSString *actual = [element label];

            NSString *expected = [NSString stringWithFormat:@"Ça va? - %@", text];

            XCTAssertEqualObjects(actual, expected);
        }

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


/*
 * Entering long text occassionally fails with DeviceAgent
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

 */

/*
 * The time between taps change change per Xcode version.
- (void)testDoubleTapTimings {

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
 */

@end

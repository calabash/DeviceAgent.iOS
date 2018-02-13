
#import <XCTest/XCTest.h>
#import <AppCenterXCUITestExtensions/AppCenterXCUITestExtensions.h>

@interface CBXDylibInjectionTest : XCTestCase

@property (strong) XCUIApplication *app;

@end

@implementation CBXDylibInjectionTest

- (void)setUp {
    [super setUp];

    [XCUIDevice sharedDevice].orientation = UIInterfaceOrientationPortrait;
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 2.0, false);

    self.app = [[XCUIApplication alloc] init];
    [ACTLaunch launchApplication:self.app];
}

- (void)tearDown {
    [XCUIDevice sharedDevice].orientation = UIInterfaceOrientationPortrait;
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 2.0, false);

    self.app = nil;
    [super tearDown];
}

- (BOOL)executingOnAppCenter {
    NSDictionary *runnerEnv = [[NSProcessInfo processInfo] environment];
    // A little brittle; depends on XTC implementation.  If the of the XTC
    // configuration files changes, this test will break.
    return [runnerEnv[@"XCTestConfigurationFilePath"]
            containsString:@"XTC.xctestconfiguration"];
}

- (void)testDylibsWereInjected {
    [self.app.tabBars.buttons[@"Misc"] tap];
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 2.0, false);
    act_label(@"Looking at the Misc page");

    [self.app.cells[@"gemuse me row"] tap];
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 2.0, false);
    act_label(@"Looking at the Gemüse Me page");

    NSLog(@"process arguments: %@", [[NSProcessInfo processInfo] arguments]);
    NSLog(@"process environment: %@", [[NSProcessInfo processInfo] environment]);

    NSLog(@"aut arguments: %@", [self.app launchArguments]);
    NSLog(@"aut environment: %@", [self.app launchEnvironment]);

    if (![self executingOnAppCenter]) {
        NSLog(@"Executing tests locally.");
        XCTAssert(self.app.cells[@"i am not gemüsed row"].exists,
                  @"Expected an 'I am not gemüsed row' when running locally");
        XCTAssert(self.app.cells[@"tomato: still a fruit row"].exists,
                  @"Expected a 'tomato: still a fruit row' when running locally");
    } else {
        NSLog(@"Executing tests on AppCenter.");

        XCTAssert(self.app.cells[@"tomato: promoted to vegetable row"].exists,
                  @"Expected a 'tomato: protomted to vegetable row' when running on AppCenter");

        XCTAssert(self.app.staticTexts[@"Beta Vulgaris"].exists,
                  @"Expect a Beta Vulgaris row because libBetaVulgaris.dylib was injected");

        XCTAssert(self.app.staticTexts[@"Brassica"].exists,
                  @"Expect a Brassica row because libBrassica.dylib was injected.");

        XCTAssert(self.app.staticTexts[@"Curcubits"].exists,
                  @"Expect a Curcubits row because libCurcubits.dylib was injected.");
    }
}

@end

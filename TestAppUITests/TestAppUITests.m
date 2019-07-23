//
//  TestAppUITests.m
//  TestAppUITests
//
//  Created by  Sergey Dolin on 23/07/2019.
//  Copyright © 2019 Calabash. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface TestAppUITests : XCTestCase

@end

@implementation TestAppUITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = YES;

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)tryUIWebViewOfRowID:(NSString*) rowId {
    // UI tests must launch the application that they test.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    XCUIElement* docLoaded = app.staticTexts[@"Document Loaded!"];
    NSPredicate* docLoadedExists = [NSPredicate predicateWithFormat:@"exists == true"];
    
    [self expectationForPredicate:docLoadedExists evaluatedWithObject:docLoaded handler:nil];
    
    [app.buttons[@"Misc"] tap];
    [app.tables.cells[rowId] tap];
    
    [self waitForExpectationsWithTimeout:15 handler:nil];

    XCUIElement* firstname = [app.webViews.textFields elementBoundByIndex:0];
    [firstname tap];
    [firstname typeText:@"123"];

    NSString* v0 = firstname.value;    // v0    __NSCFString *    @"\U0000fffc"    0x0000600002d19a00
    XCTAssertEqualObjects(v0, @"123"); // ((v0) equal to (@"123")) failed: ("￼") is not equal to ("123")
}

- (void)testUIWebView {
    [self tryUIWebViewOfRowID: @"uiwebview row"];
}


- (void)testWKWebView {
    [self tryUIWebViewOfRowID: @"wkwebview row"];
}


- (void)testSafariWebControllerWebView {
    [self tryUIWebViewOfRowID: @"safari web controller row"];
}

@end


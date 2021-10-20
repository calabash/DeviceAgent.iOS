
#import <XCTest/XCTest.h>

@interface XCWebViews : XCTestCase

@end

@implementation XCWebViews

- (void)setUp {
    self.continueAfterFailure = YES;
}

- (void)tearDown {
}

- (BOOL)spinRunLoopWithTimeout:(NSTimeInterval)timeout untilTrue:( BOOL (^)(void) )untilTrue
{
  NSDate *date = [NSDate dateWithTimeIntervalSinceNow:timeout];
  while (!untilTrue()) {
    @autoreleasepool {
      if (timeout > 0 && [date timeIntervalSinceNow] < 0) {
        return NO;
      }
      // Wait for 100ms
        [NSRunLoop.currentRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
  }
  return YES;
}

- (void)tryUIWebViewOfRowID:(NSString*) rowId {
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

    [self spinRunLoopWithTimeout:2 untilTrue:^BOOL{
        return [firstname.value  isEqual: @"123"];
    }];
    
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


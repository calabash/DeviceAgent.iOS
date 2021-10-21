#import <XCTest/XCTest.h>


@interface Dismiss : XCTestCase

@property(strong) XCUIApplication *app;

@end

@implementation Dismiss

//  XCTestCase+DHTestingAdditions.m
//  UITestingTesting
//
//  Created by Daniel Hall on 6/27/15.
//  Copyright © 2015 Daniel Hall. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
-(void)waitUntilElementExists:(XCUIElement *)element withTimeout:(NSTimeInterval)timeout {
    NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
    while (!element.exists) {
        if ([NSDate timeIntervalSinceReferenceDate] - startTime > timeout) {
            XCTFail(@"Timed out waiting for element to exist");
            return;
        }
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.1, false);
    }
}

- (void)setUp {
    [super setUp];

    self.app = [[XCUIApplication alloc] init];
    [self.app launch];
}

- (void)tearDown {
    [super tearDown];
}

// The first Privacy Alert is dismissed, but the next is not.
//
// There is an open radar.
//
// http://tinyurl.com/jgsnaxb
- (void)testDismiss {

    [self addUIInterruptionMonitorWithDescription:@"Outer Handler" handler:^BOOL(XCUIElement *alert) {
        BOOL handled = NO;
        XCUIElement *allowButton = alert.buttons[@"Allow"];
        if (allowButton.exists) {
            [allowButton tap];
            handled = YES;
        }

        XCUIElement *okButton = alert.buttons[@"OK"];
        if (okButton.exists) {
            [okButton tap];
            handled = YES;
        }
        return handled;
    }];

    XCUIElement *element = self.app.tables[@"table"].cells[@"reminders"];
    [self waitUntilElementExists:element withTimeout:5];
    [element tap];

    element = self.app.tables[@"table"].cells[@"calendar"];
    [self waitUntilElementExists:element withTimeout:5];
    [element tap];

    element = self.app.tables[@"table"].cells[@"health kit"];
    [self waitUntilElementExists:element withTimeout:5];
    [element tap];
    
    [NSThread sleepForTimeInterval:5.0f];
    
    NSArray<XCUIElement *>* buttons = self.app.buttons.allElementsBoundByIndex;
    NSArray<XCUIElement *>* switches = self.app.switches.allElementsBoundByIndex;
    NSArray<XCUIElement *>* staticTexts = self.app.staticTexts.allElementsBoundByIndex;
    
    NSString* switchTitle = [switches[0] title];
    [switches[0] tap];
    [buttons[1] tap];
    
    element = self.app.tables[@"table"].cells[@"dog food"];
    [self waitUntilElementExists:element withTimeout:120];
    [element tap];
}

@end

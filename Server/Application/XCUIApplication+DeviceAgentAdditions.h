
#import <Foundation/Foundation.h>
#import "XCUIApplication.h"

@class XCElementSnapshot;

/**
 A category to provide convenience methods on XCUIApplication.
 */
@interface XCUIApplication (DeviceAgentAdditions)

/**
 XCUIApplication interfaceOrientation returns a UIInterfaceOrientation enum
 which is an NSInteger type.  XCUITouchPath and the TestManager interface
 expect the long long type.
 */
- (long long)longLongInterfaceOrientation;

/**
 Accessibility is active if the XCUIApplicationProcess that is backing this
 XCUIApplication instance responds YES to accessibilityActive.

 @return YES if accessibility is active before timeout.
 */
- (BOOL)cbx_waitUntilAccessibilityActive;

/**
 An XCUIApplication is idle when:

 1. _waitForQuiescence is called,
 2. the underlying XCUIApplicationProcess event queue has idled, and
 3. animations in the underlying XCUIApplicationProcess have completed.

 This is an attempt to reproduce the chain of events we see when running native
 XCUITest tests.

 See the method definition for experiments to run.  The concept of an idle app
 is a work in progress.

 @return YES if accessibility is active before timeout.
 */
- (BOOL)cbx_waitUntilIdle;

/**
 Returns the lastSnapshot after calling #resolve.

 @return an XCElementSnapshot.
 */
- (XCElementSnapshot *)cbx_resolvedSnapshot;

@end

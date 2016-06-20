#import <Foundation/Foundation.h>
#import "XCUIApplication.h"


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

@end

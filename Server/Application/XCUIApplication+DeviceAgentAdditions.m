#import "XCUIApplication+DeviceAgentAdditions.h"

@implementation XCUIApplication (DeviceAgentAddtions)

- (long long)longLongInterfaceOrientation {
    return (long long)[self interfaceOrientation];
}

@end

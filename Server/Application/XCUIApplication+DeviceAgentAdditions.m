
#import "XCUIApplication+DeviceAgentAdditions.h"

@implementation XCUIApplication (DeviceAgentAdditions)

- (long long)longLongInterfaceOrientation {
    return (long long)[self interfaceOrientation];
}

@end

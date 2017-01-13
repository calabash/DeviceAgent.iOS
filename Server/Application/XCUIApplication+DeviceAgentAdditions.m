
#import "XCUIApplication+DeviceAgentAdditions.h"
#import "CBXMachClock.h"
#import "XCUIApplicationImpl.h"
#import "XCUIApplicationProcess.h"
#import "XCUIElement.h"
#import "XCElementSnapshot.h"
#import "XCApplicationQuery.h"
#import "CBXConstants.h"

@implementation XCUIApplication (DeviceAgentAdditions)

- (long long)longLongInterfaceOrientation {
    return (long long)[self interfaceOrientation];
}

- (BOOL)cbx_accessibilityActive {
    XCUIApplicationImpl *impl = [self applicationImpl];
    if (!impl) {
        DDLogError(@"ERROR: there is no application implementation for application");
        return YES;
    }

    XCUIApplicationProcess *process = [impl currentProcess];
    if (!process) {
        DDLogError(@"ERROR: there is no application process for application implementation");
        return YES;
    }

    return [process accessibilityActive];
}

- (BOOL)cbx_waitUntilAccessibilityActive {
    NSTimeInterval startTime = [[CBXMachClock sharedClock] absoluteTime];
    NSTimeInterval endTime = startTime + 10.0;

    BOOL active = NO;

    while (!active && [[CBXMachClock sharedClock] absoluteTime] < endTime) {
        active = [self cbx_accessibilityActive];
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.1, false);
    }

    NSTimeInterval elapsed = [[CBXMachClock sharedClock] absoluteTime] - startTime;
    if (!active) {
        DDLogDebug(@"Application accessibility not active after: %@ seconds", @(elapsed));
    } else {
        DDLogDebug(@"Application accessibility active after: %@ seconds", @(elapsed));
    }
    return active;
}

- (BOOL)cbx_isIdle {

    XCUIApplicationImpl *impl = [self applicationImpl];
    if (!impl) {
        DDLogDebug(@"ERROR: there is no application implementation for current application");
        return YES;
    }

    XCUIApplicationProcess *process = [impl currentProcess];
    if (!process) {
        DDLogError(@"ERROR: there is no application process for current application implementation");
        return YES;
    }

    if (![process hasReceivedEventLoopHasIdled]) {
        NSTimeInterval startTime = [[CBXMachClock sharedClock] absoluteTime];
        // Can block for a long time - up to 120 seconds.  This usually means the test
        // ecosystem has become unstable.
        [self _waitForQuiescence];
        NSTimeInterval elapsed = [[CBXMachClock sharedClock] absoluteTime] - startTime;
        DDLogDebug(@"Waited %@ seconds for quiescence while checking for event loop idle", @(elapsed));

        if (elapsed > 5.0) {
            DDLogDebug(@"Application state: %@ after waiting for %@", @([self state]), @(elapsed));
        }
    }

    // NOTE: XCUIApplication does not respond to #eventLoopIsIdle even though it is in the
    // XCUIApplication.h header.
    return [process eventLoopHasIdled] && [process animationsHaveFinished];
}

- (BOOL)cbx_waitUntilIdle {
    NSTimeInterval startTime = [[CBXMachClock sharedClock] absoluteTime];
    NSTimeInterval endTime = startTime + 5.0;

    BOOL idle = NO;

    // cbx_isIdle makes a call to `_waitForQuiescence` which can block for up to 120
    // seconds and in turn can cause this while loop to run past the 5.0 second timeout.
    // This usually means the test ecosystem has become unstable.
    while (!idle && [[CBXMachClock sharedClock] absoluteTime] < endTime) {
        idle = [self cbx_isIdle];
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.1, false);
    }

    NSTimeInterval elapsed = [[CBXMachClock sharedClock] absoluteTime] - startTime;
    if (!idle) {
        DDLogDebug(@"Application event loop was not idle after: %@ seconds", @(elapsed));
    } else {
        DDLogDebug(@"Application event loop was idle after: %@ seconds", @(elapsed));
    }

    return idle;
}

- (XCElementSnapshot *)cbx_resolvedSnapshot {
    // Application#query and Application#applicationQuery are the same object
    // Application#clearQuery recreates this instance.
    // No effect on:
    // Enqueue Failure: UI Testing Failure - Hit test for element returned an element that
    // is not found in the snapshot but is for the same application."
    //
    // No effect on:
    // Timed out waiting for key event.
    // [self clearQuery];

    // Defaults to NO.
    // Appears to slow down the wait for quiescence
    // Has no effect on Enqueue Failure - Hit test.
    // Appears to reduce the number of `Timed out waiting for key event` failures.
    // TODO empirical data about speed
    self.safeQueryResolutionEnabled = YES;

    if (![self lastSnapshot]) {
        [[self applicationQuery] elementBoundByIndex:0];
        [self resolve];
        [self cbx_waitUntilIdle];
    }
    return [self lastSnapshot];
}

@end

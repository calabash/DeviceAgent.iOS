@meta
Feature: Meta Routes

@info
Scenario: Calling meta routes
Given the app has launched
Then I can ask for the pid of the AUT
And I can ask for the test-session identifier
And I can ask for information about the device under test
And I can ask about the build attributes of the DeviceAgent

@springboard
@springboard_alerts
@not_local_devices
Scenario: SpringBoard alerts
Given the app has launched
Then I can tell DeviceAgent not to automatically dismiss SpringBoard alerts
Then I can tell DeviceAgent to automatically dismiss SpringBoard alerts

Scenario: XCUIElement types
Given the app has launched
Then I can compare Xcode element types with DeviceAgent supported element types

@term
Scenario: Terminating the AUT on POST /session
Given the app has launched
And I make a note of the AUT pid and test-session identifier
And I am looking at the Misc tab
When I POST /session again with term-on-launch true
Then I can tell the AUT has quit because I see the Touch tab
And I can tell the AUT has quit because the pid is different
And the DeviceAgent test-session has not changed

@term
Scenario: Disabling terminating the AUT on POST /session
Given the app has launched
And I make a note of the AUT pid and test-session identifier
And I am looking at the Misc tab
When I POST /session again with term-on-launch false
Then I can tell the AUT was not quit because I see the Misc tab
And I can tell the AUT has not quit because the pid is the same
And the DeviceAgent test-session has not changed

@term
Scenario: Terminating the AUT with POST /terminate
Given the app has launched
And I make a note of the AUT pid and test-session identifier
When I POST /terminate
Then the AUT pid is zero
When I POST /session again with term-on-launch false
Then I can tell the AUT has quit because I see the Touch tab
And I can tell the AUT has quit because the pid is different
And the DeviceAgent test-session has not changed

@term
@not_xtc
Scenario: DELETE /session
Given the app has launched
And I make a note of the AUT pid and test-session identifier
When I DELETE /session
Then the AUT pid is zero

@crash
Feature: DeviceAgent Crashes

Background: App has launched
Given the app has launched

# After dismissing an alert, it is natural to wait for the view to disappear.
#
# Alert is a an XCUIElement type.  Dismissing an alert causes an animation.
# Querying for the alert view _title_ too soon after the dismiss causes
# exceptions to be thrown in:
#
# * [element hitable]
# * [element hitPointCoordinate]
# * [[element hitPointCoordinate] screenPoint]
#
# after which the DeviceAgent terminates with:
#
# > testmanagerd exiting, idle with no test activity.
# > CBX-Runner: Service exited with abnormal code: 1
# > CBX-Runner: exited voluntarily.
#
# despite the exceptions being caught in JSONUtils.
#
# Waiting for the alert _message_ is not a problem; it can be done without delay.
Scenario: Querying too soon for an alert title after dismissing an alert
And I am looking at the Touch tab
Then I can dismiss an alert and wait for the alert message to disappear
And I can dismiss an alert, wait for a while, and wait for the alert title to disappear
But if I dismiss an alert and query for the alert title without sleeping
Then the DeviceAgent terminates

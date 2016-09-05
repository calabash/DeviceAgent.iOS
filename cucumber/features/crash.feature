@crash
Feature: DeviceAgent Crashes

Background: App has launched
Given the app has launched

# After dismissing an alert, it is natural to wait for the view to disappear.
#
# Alert is a an XCUIElement type.  Dismissing an alert causes an animation.
# Querying for the alert view attributes too soon after the dismiss causes
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
# Update for Xcode beta 6 and DeviceAgent >= 0.1.0: crash does not happen
# Update for Xcode beta 6 and DeviceAgent >= 0.1.0 on iOS 9.3.*: crash happens
Scenario: Querying too soon for an alert title after dismissing an alert
And I am looking at the Touch tab
And I can dismiss an alert, wait for a while, and wait for the alert title to disappear
Then I dismiss an alert and query for the alert title without sleeping
Then the DeviceAgent may or may not crash

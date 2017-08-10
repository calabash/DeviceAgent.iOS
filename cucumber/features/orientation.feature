@orientation
Feature: Changing Orientation

Background: App has launched
Given the app has launched
And I am looking at the Touch tab

Scenario: Rotating the app
Then I rotate the device so the home button is on the top
Then I rotate the device so the home button is on the left
Then I rotate the device so the home button is on the right
Then I rotate the device so the home button is on the bottom
And the server can report device and app orientations

@shutdown_after
Scenario: 00 Start in portrait: rotate to landscape
Then I rotate the device so the home button is on the left

Scenario: 01 Start in portrait: when server starts, it rotates to portrait
Then the app is in portrait after it is launched by DeviceAgent

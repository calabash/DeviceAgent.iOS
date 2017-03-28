@meta
Feature: Meta Routes

Scenario: Calling meta routes
Given the app has launched
Then I can ask for the server version
And I can ask for the session identifier
And I can ask for information about the device under test
And I can ask for the pid of the server

@springboard
@springboard_alerts
Scenario: SpringBoard alerts
Given the app has launched
Then I can tell DeviceAgent not to automatically dismiss SpringBoard alerts
Then I can tell DeviceAgent to automatically dismiss SpringBoard alerts

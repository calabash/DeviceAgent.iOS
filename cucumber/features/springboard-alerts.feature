@simulator
@springboard_alerts
Feature: Interacting with SpringBoard Alerts

Background: Navigate to Alerts and Sheets page
Given the app has launched
And I am looking at the Misc tab
And I am looking at the Alerts and Sheets page

@reset_device
Scenario: Auto-dismiss contacts
When DeviceAgent is dismissing alerts automatically
When I touch the Contacts row
Then the Contacts Privacy alert appears
And the next query dismisses the alert
When I touch the Calendar row
Then the Calendar Privacy alert appears
And the next gesture dismisses the alert

@reset_device
Scenario: Dismiss Alerts Manually
When DeviceAgent is not dismissing alerts automatically
When I touch the Reminders row
Then the Reminders Privacy alert appears
And the next query does not dismiss the alert
And the next gesture does not dismiss the alert
But I can dismiss the SpringBoard alert by touching OK

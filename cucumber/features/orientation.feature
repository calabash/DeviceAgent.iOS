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


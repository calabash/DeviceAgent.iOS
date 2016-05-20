@touch
Feature: Touch

Background: App has launched
Given the app has launched

Scenario: Single finger touch
And I am looking at the Touch tab
Then I can tap the screen by coordinate

Scenario: Two finger touch
And I am looking at the Touch tab
Then I can tap with two fingers by coordinate

@wip
Scenario: Double tap
Given I am looking at the Tao tab
Given I rotate the device so the home button is on the bottom
Then I double tap the button
And I clear the touch action label
#When I rotate the device so the home button is on the left
#Then I double tap the button
#When I rotate the device so the home button is on the right
#And I clear the touch action label
#Then I double tap the button


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

Scenario: Double tap in any orientation
Given I am looking at the Tao tab
Given I rotate the device so the home button is on the bottom
Then I double tap the little button
And I clear the touch action label

@wip
Scenario: Tap in any orientation
Given I am looking at the Tao tab
Given I rotate the device so the home button is on the bottom
Then I tap the little button
And I clear the touch action label


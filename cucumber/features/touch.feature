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
Scenario: Tapping in portrait
Given I am looking at the Tao tab
Given I rotate the device so the home button is on the bottom
And I can see the buttons in the action box
And I can see the button action label
Then I double tap the button
#And I tap the button
#And I long press the button
#And I triple tap the button
#And I two finger long press the button
#And I three finger tap the button
#And I two finger tap double tap the button


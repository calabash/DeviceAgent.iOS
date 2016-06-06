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

@orientation
Scenario: Double tap in any orientation
Given I am looking at the Tao tab
Given I rotate the device so the home button is on the bottom
Then I double tap a little button
And I clear the touch action label

@orientation
Scenario: Touch in any orientation
Given I am looking at the Tao tab
And I rotate the device so the home button is on the bottom
Then I touch a little button
Then I rotate the device so the home button is on the left
Then I touch a little button
Then I rotate the device so the home button is on the right
Then I touch a little button
Then I rotate the device so the home button is on the top
Then I touch a little button

@orientation
Scenario: Triple tap in any orientation
Given I am looking at the Tao tab
And I rotate the device so the home button is on the bottom
Then I triple tap a little button
Then I rotate the device so the home button is on the left
Then I triple tap a little button
Then I rotate the device so the home button is on the right
Then I triple tap a little button
Then I rotate the device so the home button is on the top
Then I triple tap a little button

@long_press
Scenario: Long press durations
Given I am looking at the Tao tab
Given I rotate the device so the home button is on the bottom
Then I long press a little button for a short time
Then I long press a little button for enough time
Then I long press a little button for a long time

@orientation
@long_press
Scenario: Long press in any orientation
Given I am looking at the Tao tab
Given I rotate the device so the home button is on the bottom
Then I long press a little button for enough time
Then I rotate the device so the home button is on the left
Then I long press a little button for enough time
Then I rotate the device so the home button is on the right
Then I long press a little button for enough time
Then I rotate the device so the home button is on the top
Then I long press a little button for enough time


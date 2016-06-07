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
When the home button is on the bottom, I can double tap
When the home button is on the right, I can double tap
When the home button is on the left, I can double tap
When the home button is on the top, I can double tap

Scenario: Touch in any orientation
Given I am looking at the Tao tab
And I rotate the device so the home button is on the bottom
When the home button is on the bottom, I can touch
When the home button is on the right, I can touch
When the home button is on the left, I can touch
When the home button is on the top, I can touch

Scenario: Triple tap in any orientation
Given I am looking at the Tao tab
When the home button is on the bottom, I can triple tap
When the home button is on the left, I can triple tap
When the home button is on the right, I can triple tap
When the home button is on the top, I can triple tap

Scenario: Long press durations
Given I am looking at the Tao tab
Then I long press a little button for a short time
Then I long press a little button for enough time
Then I long press a little button for a long time

Scenario: Long press in any orientation
Given I am looking at the Tao tab
When the home button is on the top, I can long press
When the home button is on the right, I can long press
When the home button is on the left, I can long press
When the home button is on the bottom, I can long press

Scenario: Two finger tap in any orientation
Given I am looking at the Tao tab
When the home button is on the left, I can two-finger tap
When the home button is on the top, I can two-finger tap
When the home button is on the right, I can two-finger tap
When the home button is on the bottom, I can two-finger tap

Scenario: Three finger tap in any orientation
Given I am looking at the Tao tab
When the home button is on the right, I can three-finger tap
When the home button is on the bottom, I can three-finger tap
When the home button is on the top, I can three-finger tap
When the home button is on the left, I can three-finger tap

Scenario: Four finger tap in any orientation
Given I am looking at the Tao tab
When the home button is on the top, I can four-finger tap
When the home button is on the left, I can four-finger tap
When the home button is on the right, I can four-finger tap
When the home button is on the bottom, I can four-finger tap

Scenario: Two finger double tap in any orientation
Given I am looking at the Tao tab
When the home button is on the right, I can two-finger double tap
When the home button is on the top, I can two-finger double tap
When the home button is on the bottom, I can two-finger double tap
When the home button is on the left, I can two-finger double tap

Scenario: Two finger long press in any orientation
Given I am looking at the Tao tab
When the home button is on the bottom, I can two-finger long press
When the home button is on the top, I can two-finger long press
When the home button is on the right, I can two-finger long press
When the home button is on the left, I can two-finger long press


@pan
Feature: Pan
In order to drag and drop, swipe, flick, and scroll
As an iOS UI Tester
I want a pan API

Background: Navigate to Pan page
Given the app has launched
And I am looking at the Pan tab

Scenario: Visual confirmation of drag
And I am looking at the Pan Palette page
Then I can pan with 1 finger
Then I can pan with 2 fingers
Then I can pan with 3 fingers
Then I can pan with 4 fingers
Then I can pan with 5 fingers
But I cannot pan with 6 fingers
And I can pan quickly
And I can pan slowly

Scenario: Visual confirmation of drag and drop
And I am looking at the Drag and Drop page
Then I can drag the red box to the right well

Scenario: Scrolling
And I am looking at the Everything's On the Table page
Then I can scroll down to the Windows row
And then back up to the Apple row

Scenario: Flicking
And I am looking at the Everything's On the Table page
Given I see the Apple row
Then I can flick to the bottom of the company table
Then I can flick to the top of the company table

Scenario: Swipe to delete
And I am looking at the Everything's On the Table page
Then I can flick to the bottom of the company table
And I can swipe to delete the Windows row

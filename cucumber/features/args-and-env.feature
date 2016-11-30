Feature: Launching with args and env

Background:
Given the app has launched
And I am looking at the Misc tab

@args
Scenario: Arguments
And I am looking at the Arguments page
Then I see the app was launched with the correct arguments

@env
Scenario: Environment
And I am looking at the Environment page
Then I see the app was launched with the correct environment

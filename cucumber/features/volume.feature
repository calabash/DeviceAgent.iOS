@volume
Feature: Volume

Scenario: Can control the volume
Given the app has launched
And I am looking at the Misc tab
Then I can turn the volume up
And I can turn the volume down
And sending an invalid volume direction raises an error


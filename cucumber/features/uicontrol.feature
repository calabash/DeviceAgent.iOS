@controls
Feature: UIControls

Background: App has launched
Given the app has launched
And I am looking at the Touch tab

Scenario: Interacting with UISwitch
Then I can find the on-off switch by identifier
And I can find the on-off switch by type
Then the on-off switch is on
Then I can turn the switch off

Scenario: Interacting with UISegmentedControl
Then I can find the segmented control by identifier
And I can find the segmented control by type
Then the First control is selected
When I touch the Second control
Then the Second control is selected
When I touch the Third control
Then the Third control is selected

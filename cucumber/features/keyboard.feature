@keyboard
Feature: Keyboard

Background: App has launched
Given the app has launched
And I am looking at the Text Input page
And the text field and question label are reset

Scenario: Keyboard must be visible
When I try to type without the keyboard
Then a keyboard-not-visible error is raised

Scenario: Entering text triggers UITextInput delegates
When I touch the text field
Then the keyboard is visible
When I type "Bien"
Then what I typed appears in the red box

Scenario: Text with single quotes
Given I typed "Gut, und du? Wie geht's?"
Then what I typed appears in the red box

Scenario: Deleting text with \b
Given I typed "Dangge, guet, und dir?"
And I decide I should be more formal
Then I replace "dir?" with "Ihre?" by sending backspace

@delete_key
Scenario: Deleting text by touching delete key
Given I typed "Tack, bra."
And I decide I want to be more emphatic
Then I replace "." with "!" using the delete key

@clear_text
Scenario: Deleting text using clear text
Given I typed "Tack, bra."
And I clear the text
Then I should see an empty text field

@text_view
Scenario: Typing in a TextView
Given I touched the Text View
Then I can clear the Text View
Then I can type a lot of text
And I can dismiss the Text View keyboard
And I can select all the text in the Text View
And I can clear the Text View after selecting all using the delete key or Cut
And I can dismiss the Text View keyboard

@alert
@alert_text_field
Scenario: Typing in an Alert Text Field
Given I touch the Alert nav bar button
Then I see an authentication alert
And I enter my name for authentication
And I enter my password for authentication
Then I submit my credentials for authentication

@key_input
Scenario: Typing in a UIKeyInput view
Given I touched the UIKeyInput view
When I try to use the clear text gesture on the UIKeyInput view
Then an error is raised because DeviceAgent cannot find a first responder
Then I type some text in the UIKeyInput view
Then I can delete text in the UIKeyInput view by tapping the keyboard delete key
And I dismiss the UIKeyInput keyboard by tapping the return button

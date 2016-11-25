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

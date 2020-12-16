@query
Feature: Query
In order to test for the existence of UI elements
As a UI tester
I want a query API

Background: App has launched
Given the app has launched

@marked
Scenario: Querying by mark
And I am looking at the Touch tab
Then I query for the Silly Alpha button by mark using id
Then I query for the Silly Zero button by mark using the title
Then I find the button behind the purple label using marked and :all
But I cannot find the button behind the purple label using marked without :all
And I am looking at the Query page
Then I query for Same as views by mark using id
Then I query for Same as views by mark using id and filter by TextField
Then I query for Same as views by mark using id and filter by TextView
Then I query for Same as views by mark using id and use an index to find the Button

# % is an Objective-C format directive
# ? is a special character when using LIKE in NSPredicate
# Single quotes can be handled with \ or without
# Double quotes can be handled with \ or without
# Tabs can be handle with \t or without
# Querying for marks with newlines works in Xcode >= 9.3.
@escaping
Scenario: Queries with special characters
And I am looking at the Query page
Then I query for the 110 percent by text and mark
Then I query for the text with a question mark
Then I query for Karl's Problem using a backslash to escape the quote
Then I query for Karl's Problem without a backslash
Then I query for the text in quotes using backslashes
Then I query for the text in quotes without using backslashes
Then I query for the label with the TAB by escaping the tab char
Then I query for the label with the TAB without escaping the tab char
And querying for text with newlines works for Xcode 9.3 and above

@utf8
Scenario: Query supports multiple languages
Then I am looking at the Touch tab
Then I can query for Japanese

@wildcard
Scenario: Query supports "*"
Then I am looking at the Touch tab
Then an empty hash query returns between 8 and 37 elements
And an empty hash query with :all returns between 14 and 43 elements

@tree
Scenario: Can ask for a tree representation
And I am looking at the Query page
Then I ask for the tree representation of the view hierarchy

@timed
Scenario: Time queries
And I am looking at the Query page
Then I time how long it takes to make a bunch of queries

@query
Scenario: Query returns the correct 'value' for element
And I am looking at the Text Input with placeholder
Then I query the text field using "type" with string "TextField" and see value "Schreib!"
Then I query the text field using "id" with string "text field" and see value "Schreib!"
Then I query the text field using "marked" with string "text field" and see value "Schreib!"
Then I query the text field using "marked" with string "Schreib!" and see value "Schreib!"
Then I query the text field using "text" with string "Schreib!" and see value "Schreib!"
Then I touch the text field
When the keyboard is visible
And I type "Hello!"
Then I query the text field using "type" with string "TextField" and see value "Hello!"
Then I query the text field using "id" with string "text field" and see value "Hello!"
Then I query the text field using "marked" with string "text field" and see value "Hello!"
Then I query the text field using "marked" with string "Schreib!" and see value "Hello!"
Then I query the text field using "marked" with string "Hello!" and see value "Hello!"
Then I query the text field using "text" with string "Schreib!" and see value "Hello!"
Then I query the text field using "text" with string "Hello!" and see value "Hello!"

@query
Scenario: Descendant query returns array of elements
Given I am looking at the Text Input with placeholder
And   I touch the text field
When the keyboard is visible
Then I query the keyboard using "descendant_element" and see keyboard buttons
  | parent_type | descendant_type |
  | Keyboard    | Button          |

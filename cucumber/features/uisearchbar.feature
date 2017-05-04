@keyboard
@search_bar
Feature: Interacting with UISearchBar

Background: App has launched
Given the app has launched
And I am looking at the Pan tab
And I am looking at the Everything's On the Table page

Scenario: Typing filters results
When I type A in the company search bar
Then the search results are Amazon, Apple, and Android
Then I dismiss the keyboard by tapping the Search key
Then I dismiss the search results by touching the Cancel button
Then I can see the Basecamp row

Scenario: Clearing text
Then I type A in the company search bar
Then I clear text with the clear button in the search bar
Then I type A in the company search bar
Then I clear the search bar text with the clear text route
Then I dismiss the search results by touching the Cancel button

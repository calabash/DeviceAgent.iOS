@webview
Feature: UIWebView and WKWebView

Background: App has launched
Given the app has launched
And I am looking at the Misc tab

@keyboard
@uiwebview
Scenario: Interacting with UIWebView text field
Given I am looking at the UIWebView
And I scroll down to the first and last name text fields
When I touch the first name text field
Then the first name text field has keyboard focus
And I can type my first name
Then I clear my first name using the clear text route

@keyboard
@uiwebview
Scenario: Interacting with WKWebView text field
Given I am looking at the WKWebView
And I scroll down to the first and last name text fields
When I touch the first name text field
Then the first name text field has keyboard focus
And I can type my first name
Then I clear my first name using the clear text route

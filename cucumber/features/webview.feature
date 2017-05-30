@webview
Feature: UIWebView, WKWebView, and SafariWebController

Background: App has launched
Given the app has launched
And I am looking at the Misc tab

@keyboard
@uiwebview
Scenario: Interacting with UIWebView text field
Given I am looking at the UIWebView
And I scroll down to the first and last name text fields
Then I type my first name
Then I clear my first name using the clear text route

@keyboard
@uiwebview
Scenario: Interacting with WKWebView text field
Given I am looking at the WKWebView
And I scroll down to the first and last name text fields
Then I type my first name
Then I clear my first name using the clear text route

@keyboard
@safari
Scenario:  Interacting with SafariWebController
Given I am looking at the SafariWebController
And I scroll down to the first and last name text fields
Then I type my first name
Then I clear my first name using the clear text route

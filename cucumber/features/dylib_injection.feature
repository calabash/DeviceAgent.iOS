Feature: Dylib Injection

Background:
Given the app has launched
And I am looking at the Misc tab

@dylib_injection
Scenario: Inject dylibs on App Center
And I am looking at the Gemuse Me page
When running in App Center the Gemuse Bouche libs are loaded
When running locally the Gemuse Bouche libs are not loaded

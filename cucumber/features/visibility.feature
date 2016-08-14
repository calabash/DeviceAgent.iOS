@visibility
Feature: Visibility
In order to test gestures
As a UI tester
I want to know if a view is visible

Background: App has launched
Given the app has launched
And I am looking at the Touch tab

# The run-loop ruby client filters by "hitable" = true
#
# Sending the option :all => true will return all views in the hierarchy. This
# is similar to query("all *").
#
# Views that have alpha 0 are not hitable.
# Views that have size 0,0 are not hitable.
Scenario: What is hitable?
Then the tab bar is visible and hitable
And the status bar is visible, but not hitable
And the disabled button is visible, hitable, but not enabled
When I touch the alpha button its alpha goes to zero
Then the alpha button is not visible and not hitable
But after a moment the alpha button is visible and hitable
When I touch the zero button its size goes to zero
Then the zero button is not visible and not hitable
But after a moment the zero button is visible and hitable

# Using an animation to move the alpha to 0 or the size to 0,0 does not make
# the view un-hitable.
#
# Why is this happening?
#
# * Setting the alpha or size outside of an animation causes hitable to be false.
# * Animating the alpha or size causes hitable to remain truthy.
#
# Using the UIViewAnimationOptionAllowUserInteraction option does not have
# an effect.
#
# Is XCUITest maintaining a cache that we need to clear?  Or is there something
# going on in the animation stack?
Scenario: Animations cause confusing hitable state
When I touch the animated button its alpha animates to zero
Then the animated button is not visible after the touch, but it is hitable
When I two finger tap the animated button its size animates to zero
Then the animated button is not visible after the tap, but it is hitable

# The run-loop ruby client filters by "hitable" = true
#
# Sending the option :all => true will return all views in the hierarchy. This
# is similar to query("all *").
#
# The label has "User Interaction Enabled" - this is enough to block touch
# events from being passed to the view below; a gesture recognizer on the label
# is not needed (but there is one).
#
# Without the "User Interaction Enabled" the label would allow the touch event
# to pass through to the button behind it.  Interesting!?!
#
# XCUITest reports non-touchable views with hit point -1, -1
Scenario: Button hidden by another view
When I query for the button behind the purple label, I get no results
But I can find the button behind the purple label using query :all
And I cannot touch the button behind the purple label using the view center
And I cannot touch the button behind the purple label using the hit point

# XCUITest says a view is "hitable" if any part of the view can be touched
#
# The label intercepts the touch event! (see above).
#
# XCUITest will return a hit point in the visible portion of the view: Hurray!
Scenario: More than half of button hidden by another view
When I query for the mostly hidden button I can find it
But I cannot touch the mostly hidden button using the view center
And I can touch the mostly hidden button using the hit point

# No surprises here.
#
# The run-loop ruby client filters by "hitable" = true and uses the center of
# the view as the touch point.
Scenario: Less than half of button hidden by another view
When I query for the mostly visible button I can find it
And I can touch the mostly visible button using the view center
And I can touch the mostly visible button using the hit point

# Views that are off screen are not hitable
#
# Trying to touch off screen causes a touch event at the closest edge
#
# #############
# #           #
# #           #
# #          A# <-- 50 --> B
# #           #
# #           #
# #############
#
# A is a button; it is invisible.  Touching it causes an Off Screen Touch alert
# to appear.
#
# B is a button located 50 points to right of the screen mid-point.  It cannot
# be touched.  Trying to touch B will touch A.
Scenario: Touching outside of the screen bounds
Given there is an invisible button centered at the right mid-point of the view
And touching that button causes an Off Screen Touch alert to be shown
When I query for the button that is off screen, I get no results
But I can find the button that is off screen using query :all
When I touch the off screen button using its center point
Then the touch happens at the right middle edge, not on the button that is off screen
And this causes the Off Screen Touch alert to show

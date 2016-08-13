
module TestApp
  module Visibility

  end
end

World(TestApp::Visibility)

When(/^I query for the button behind the purple label, I get no results$/) do
  @waiter.wait_for_no_view("hidden button")
end

But(/^I can find the button behind the purple label using query :all$/) do
  @waiter.wait_for_view("hidden button", {all: true})
end

And(/^I cannot touch the button behind the purple label using the view center$/) do
  mark = "hidden button"
  element = @waiter.wait_for_view(mark, {all: true})

  center = @gestures.send(:element_center, element)
  @gestures.touch(center[:x], center[:y])

  @waiter.wait_for_view("That was touching.")

  @gestures.two_finger_tap_mark("gesture performed")
  @waiter.wait_for_text_in_view("CLEARED", "gesture performed")
end

And(/^I cannot touch the button behind the purple label using the hit point$/) do
  element = @waiter.wait_for_view("hidden button", {all: true})

  hit_point = element["hit_point"]

  @gestures.touch(hit_point["x"], hit_point["y"])

  # Alert might take a long time to appear.
  sleep(1.0)

  @waiter.wait_for_no_view("If we can't see you, how can we touch you?")
end

When(/^I query for the mostly (hidden|visible) button I can find it$/) do |state|
  mark = "mostly #{state} button"
  @waiter.wait_for_view(mark)
end

But(/^I cannot touch the mostly hidden button using the view center$/) do
  mark = "mostly hidden button"
  @gestures.touch_mark(mark)

  @waiter.wait_for_view("That was touching.")

  @gestures.two_finger_tap_mark("gesture performed")
  @waiter.wait_for_text_in_view("CLEARED", "gesture performed")
end

But(/^I can touch the mostly visible button using the view center$/) do
  mark = "mostly visible button"
  @gestures.touch_mark(mark)

  mark = "If we can see most of you, we can touch you."
  @waiter.wait_for_view(mark)

  @gestures.touch_mark("OK")
  @waiter.wait_for_no_alert
end

And(/^I can touch the mostly (hidden|visible) button using the hit point$/) do |state|
  mark = "mostly #{state} button"

  element = @waiter.wait_for_view(mark)
  hit_point = element["hit_point"]

  @gestures.touch(hit_point["x"], hit_point["y"])

  if state == "hidden"
    mark = "If we can see part of you, we can touch you."
  else
    mark = "If we can see most of you, we can touch you."
  end

  @waiter.wait_for_view(mark)

  @gestures.touch_mark("OK")
  @waiter.wait_for_no_alert
end

Given(/^there is an invisible button centered at the right mid-point of the view$/) do
  # Documentation Step
end

And(/^touching that button causes an Off Screen Touch alert to be shown$/) do
  # Documentation Step
end

When(/^I query for the button that is off screen, I get no results$/) do
  @waiter.wait_for_no_view("off screen button")
end

But(/^I can find the button that is off screen using query :all$/) do
  @waiter.wait_for_view("off screen button", {all: true})
end

When(/^I touch the off screen button using its center point$/) do
  mark = "off screen button"
  element = @waiter.wait_for_view(mark, {all: true})
  center = @gestures.send(:element_center, element)
  @gestures.touch(center[:x], center[:y])
end

Then(/^the touch happens at the right middle edge, not on the button that is off screen$/) do
  # Documentation Step
end

And(/^this causes the Off Screen Touch alert to show$/) do
  mark = "Off Screen Touch!?!"
  @waiter.wait_for_view(mark)

  @gestures.touch_mark("OK")
  @waiter.wait_for_no_alert
end

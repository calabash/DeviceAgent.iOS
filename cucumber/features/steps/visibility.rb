
module TestApp
  module Visibility

    def element_has_an_automation_property?(element)
      type = element["type"]

      return true if type != "Window" && type != "Other"

      ["id", "label", "title", "value"].any? { |key| element[key] }
    end

    def automatable_elements(elements)
      elements.select { |element| element_has_an_automation_property?(element) }
    end

    # Exploring this as an option for the clients.  There are many elements
    # that are not interesting at all for automation.
    def query_for_automatable_elements(uiquery)
      sleep(1.0)
      automatable_elements(query(uiquery))
    end
  end
end

World(TestApp::Visibility)

Then(/^the tab bar is visible and hitable$/) do
  element = query({type: "TabBar", all: true}).first
  expect(element).to be_truthy
  # Just print for now; we need more information.
  log_inline("TabBar hitable: #{element["hitable"]}")
  # expect(element["hitable"]).to be == true
end

Then(/^the status bar is visible and sometimes hitable$/) do
  if ios_gte?("13.0")
    log_inline("StatusBar was deprecated on iOS 13+")
    wait_for_no_view({type: "StatusBar", all: true})
  elsif iphone_x? && !device_info["simulator"]
    # The StatusBar may or may not be visible on iPhone 10.
    # This is _not_ a timing issue; waiting does not change the outcome.
    element = query({type: "StatusBar", all: true}).first
    log_inline("StatusBar on iPhone X devices may or may not be visible")
    if element && element["hitable"]
      log_inline("This status bar is hitable")
    else
      log_inline("This status bar is not hitable")
    end
  else
    element = wait_for_view({type: "StatusBar", all: true})
    expect(element).to be_truthy
    # Just print for now; we need more information.
    log_inline("StatusBar hitable: #{element["hitable"]}")
    # expect(element["hitable"]).to be == true
  end
end

And(/^the disabled button is visible, hitable, but not enabled$/) do
  element = query({marked: "disabled button", all: true}).first
  expect(element).to be_truthy
  expect(element["hitable"]).to be == true
  expect(element["enabled"]).to be == false
end

When(/^I touch the (alpha|zero) button its (?:alpha|size) goes to zero$/) do |mark|
  identifier = "#{mark} button"
  touch({marked: identifier})
  wait_for_no_view({marked: identifier})
end

Then(/^the (alpha|zero) button is not visible and not hitable$/) do |mark|
  identifier = "#{mark} button"

  options = {
    :retry_frequency => 0.1,
    :timeout => 4
  }

  message = "Waited for #{options[:timeout]} seconds for #{mark} button to disappear"

  wait_for(message, options) do
    element = query({marked: identifier, all: true}).first
    if !element # Xcode 8
      true
    else # Xcode 7.3.1
      element["hitable"] == false
    end
  end
end

But(/^after a moment the (alpha|zero) button is visible and hitable$/) do |mark|
  identifier = "#{mark} button"
  wait_for_view({marked: identifier})
end

When(/^I (touch|two finger tap) the animated button its (?:alpha|size) animates to zero$/) do |gesture|
  identifier = "animated button"

  @animation_start = Time.now

  if gesture == "touch"
    touch({marked: identifier})
  else
    two_finger_tap({marked: identifier})
  end

  # First animation has duration 1.0.  Next animation starts in 3.0 seconds.
  sleep(1.5)
end

Then(/^the animated button is not visible after the (touch|tap), but it is hitable$/) do |gesture|
  identifier = "animated button"

  # The query must happen before the second animation starts.
  elapsed = Time.now - @animation_start
  expect(elapsed).to be < 12.0

  element = query({marked: identifier}).first
  expect(element).to be_truthy
  expect(element["hitable"]).to be == true

  # Was the correct gesture performed?
  if gesture == "touch"
    title = "Had Alpha Zero"
  else
    title = "Had Size Zero"
  end

  wait_for_view({marked: title})
end

When(/^I query for the button behind the purple label, I get no results$/) do
  wait_for_no_view({marked: "hidden button"})
end

But(/^I can find the button behind the purple label using query :all$/) do
  wait_for_view({marked: "hidden button", all: true})
end

And(/^I cannot touch the button behind the purple label using the view center$/) do
  mark = "hidden button"
  element = wait_for_view({marked: mark, all: true})

  center = element_center(element)
  touch_coordinate(center)
  wait_for_animations

  wait_for_view({marked: "That was touching."})

  two_finger_tap({marked: "gesture performed"})
  wait_for_text_in_view("CLEARED", {marked: "gesture performed"})
end

And(/^I cannot touch the button behind the purple label using the hit point$/) do
  element = wait_for_view({marked: "hidden button", all: true})

  hit_point = element["hit_point"]

  touch_coordinate(hit_point)

  # Alert might take a long time to appear.
  sleep(1.0)

  wait_for_no_view({marked: "If we can't see you, how can we touch you?"})
end

When(/^I query for the mostly (hidden|visible) button I can find it$/) do |state|
  mark = "mostly #{state} button"
  wait_for_view({marked: mark})
end

But(/^I cannot touch the mostly hidden button using the view center$/) do
  mark = "mostly hidden button"
  touch({marked: mark})

  wait_for_animations
  wait_for_view({marked: "That was touching."})

  two_finger_tap({marked: "gesture performed"})
  wait_for_text_in_view("CLEARED", {marked: "gesture performed"})
end

But(/^I can touch the mostly visible button using the view center$/) do
  mark = "mostly visible button"
  touch({marked: mark})

  mark = "If we can see most of you, we can touch you."
  wait_for_view({marked: mark})

  wait_for_animations
  touch({marked: "OK"})
  wait_for_no_alert
end

And(/^I can touch the mostly (hidden|visible) button using the hit point$/) do |state|
  mark = "mostly #{state} button"

  element = wait_for_view({marked: mark})
  hit_point = element["hit_point"]

  touch_coordinate(hit_point)

  if state == "hidden"
    mark = "If we can see part of you, we can touch you."
  else
    mark = "If we can see most of you, we can touch you."
  end

  wait_for_view({marked: mark})

  # The alert is clearly visible, but touching the alert too soon after it
  # appears can cause the DeviceAgent to crash.
  wait_for_animations

  touch({marked: "OK"})
  wait_for_no_alert
end

Given(/^there is an invisible button centered at the right mid-point of the view$/) do
  # Documentation Step
end

And(/^touching that button causes an Off Screen Touch alert to be shown$/) do
  # Documentation Step
end

When(/^I query for the button that is off screen, I get no results$/) do
  wait_for_no_view({marked: "off screen button"})
end

But(/^I can find the button that is off screen using query :all$/) do
  wait_for_view({marked: "off screen button", all: true})
end

When(/^I touch the off screen button using its center point$/) do
  mark = "off screen button"
  element = wait_for_view({marked: mark, all: true})
  center = element_center(element)
  touch_coordinate(center)
end

Then(/^the touch happens at the right middle edge, not on the button that is off screen$/) do
  # Documentation Step
end

And(/^this causes the Off Screen Touch alert to show$/) do
  mark = "Off Screen Touch!?!"
  wait_for_view({marked: mark})

  # Alert subviews are visible before they are touchable.
  sleep(1.0)

  touch({marked: "OK"})
  wait_for_no_alert
end

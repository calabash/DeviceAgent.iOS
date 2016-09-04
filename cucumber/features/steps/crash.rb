
module TestApp
  module Crash

  end
end

World(TestApp::Crash)

Then(/^I can dismiss an alert and wait for the alert message to disappear$/) do
  mark = "mostly visible button"
  @gestures.touch_mark(mark)

  mark = "If we can see most of you, we can touch you."
  @waiter.wait_for_view({marked: mark})

  # The OK button is visible, but not touchable.
  @waiter.wait_for_animations

  @gestures.touch_mark("OK")
  @waiter.wait_for_no_view({marked: mark})
end

And(/^I can dismiss an alert, wait for a while, and wait for the alert title to disappear$/) do
  mark = "mostly visible button"
  @gestures.touch_mark(mark)

  mark = "Mostly Visible Button"
  @waiter.wait_for_view({marked: mark})

  @gestures.touch_mark("OK")

  if RunLoop::Environment.ci?
    sleep(2.0)
  else
    sleep(1.0)
  end

  @waiter.wait_for_no_view({marked: mark})
end

Then(/^I dismiss an alert and query for the alert title without sleeping$/) do
  mark = "mostly visible button"
  @gestures.touch_mark(mark)

  mark = "Mostly Visible Button"
  @waiter.wait_for_view({marked: mark})

  @gestures.touch_mark("OK")
  @waiter.wait_for_no_view({marked: mark})
end

Then(/^on Xcode (\d+) the DeviceAgent does not crash$/) do |_|
  if RunLoop::Xcode.new.version_gte_8?
    expect(@gestures.running?).to be_truthy
  end
end

But(/^on Xcode (\d+) the DeviceAgent crashes in CI$/) do |_|
  if !RunLoop::Xcode.new.version_gte_8?
    if RunLoop::Environment.ci?
      expect(@gestures.running?).to be_falsey
    else
      expect(@gestures.running?).to be_truthy
    end
  end
end

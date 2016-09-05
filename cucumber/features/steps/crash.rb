
module TestApp
  module Crash

  end
end

World(TestApp::Crash)

And(/^I can dismiss an alert, wait for a while, and wait for the alert title to disappear$/) do
  @device_info = device_info

  mark = "mostly visible button"
  touch({marked: mark})

  mark = "Mostly Visible Button"
  wait_for_view({marked: mark})

  # The OK button is visible, but not touchable.
  wait_for_animations
  touch({marked: "OK"})

  if RunLoop::Environment.ci?
    timeout = 4.0
  elsif RunLoop::Environment.xtc?
    timeout = 3.0
  else
    timeout = 2.0
  end
  sleep(timeout)

  wait_for_no_view({marked: mark})
end

Then(/^I dismiss an alert and query for the alert title without sleeping$/) do
  mark = "mostly visible button"
  touch({marked: mark})

  mark = "Mostly Visible Button"
  wait_for_view({marked: mark})

  # The OK button is visible, but not touchable.
  wait_for_animations
  touch({marked: "OK"})

  begin
    wait_for_no_view({type: "Alert"})
  rescue Timeout::Error => _
    # See the next step.
  end
end

Then(/^the DeviceAgent may or may not crash$/) do
  if running?
    RunLoop.log_info2(%Q[
DeviceAgent did NOT crash:

Xcode: #{RunLoop::Xcode.new}

#{JSON.pretty_generate(@device_info)}

])
  else
    RunLoop.log_error(%Q[
    DeviceAgent did crash:

Xcode: #{RunLoop::Xcode.new}

#{JSON.pretty_generate(@device_info)}

])
    pending("DeviceAgent crashed after querying for an alert that was just dismissed")
  end
end

Given(/^the app has launched$/) do
  # Wait for a view
  sleep(5.0)
end

Then(/^I can tap the screen by coordinate$/) do
  @device_agent.tap_coordinate(50, 50)
  result = @waiter.wait_for_view("gesture performed")
  expect(result["value"]).to be == "Tap"
end

And(/^I have done a specific thing$/) do
  # Example: Given I am logged in
  #  wait_for do
  #    !query("* marked:'username'").empty?
  #  end
  #
  #  touch("* marked:'username'")
  #  wait_for_keyboard
  #  keyboard_enter_text("cleveruser27")
  #
  #  touch("* marked:'password'")
  #  wait_for_keyboard
  #  keyboard_enter_text("pa$$w0rd")
  #
  #  wait_for_element_exists("* marked:'Login'")
  #  touch("* marked:'Login'")

  # Remember: any Ruby is allowed in your step definitions
  did_something = true

  unless did_something
    raise 'Expected to have done something'
  end
end

When(/^I do something$/) do
  # Example: When I create a new entry
  #  tap("* marked:'new_entry'")
  #  wait_for_keyboard
  #  keyboard_enter_text("* marked:'entry_title'", 'My Entry')
  #
  #  tap("* marked:'submit'")
end

Then(/^something should happen$/) do
  # Example: Then I should see the entry on my home page
  #  wait_for_element_exists("* text:'My Entry'")
end


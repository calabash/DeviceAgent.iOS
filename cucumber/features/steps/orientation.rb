
Then(/^I rotate the device so the home button is on the (top|bottom|left|right)$/) do |position|
  @device_agent.rotate_home_button_to(position)
end

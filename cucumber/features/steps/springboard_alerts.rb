
And(/^I am looking at the Alerts and Sheets page$/) do
  if !query({marked: "Misc Menu"})
    touch_tab("Misc")
  end

  touch({marked: "alerts and sheets row"})
  wait_for_view({marked: "alerts and sheets page"})
  wait_for_animations
end

When(/^DeviceAgent is dismissing alerts automatically$/) do
  expect(set_dismiss_springboard_alerts_automatically(true)).to be_truthy
end

When(/^DeviceAgent is not dismissing alerts automatically$/) do
  expect(set_dismiss_springboard_alerts_automatically(false)).to be_falsey
end

When(/^I touch the (Contacts|Calendar|Reminders) row$/) do |row|
  touch({marked: "#{row.downcase} row"})
end

Then(/^the (Contacts|Calendar|Reminders) Privacy alert appears$/) do |tcc|
  wait_for_springboard_alert

  alert = springboard_alert

  expect(alert["alert_title"][/Access Your #{tcc}/]).to be_truthy
  # Notice the UTF-8 single quote!
  expect(alert["button_titles"]).to be == ["Don’t Allow", "OK"]
  expect(alert["type"]).to be == "Alert"
  expect(alert["is_springboard_alert"]).to be_truthy
end

And(/^the next query dismisses the alert$/) do
  query({marked: "Misc"})
  wait_for_no_springboard_alert
end

And(/^the next query does not dismiss the alert$/) do
  query({marked: "Misc"})
  expect(springboard_alert_visible?).to be_truthy
end

And(/^the next gesture dismisses the alert$/) do
  touch({marked: "Misc Menu"})
  wait_for_animations
  wait_for_no_springboard_alert
  wait_for_view({marked: "misc page"})
end

And(/^the next gesture does not dismiss the alert$/) do
  touch({marked: "Misc Menu"})
  wait_for_animations
  wait_for_view({marked: "alerts and sheets page"})
end

But(/^I can dismiss the SpringBoard alert by touching OK$/) do
  dismiss_springboard_alert("OK")
  wait_for_no_springboard_alert
end

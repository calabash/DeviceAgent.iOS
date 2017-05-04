
Given(/^I am looking at the (UIWebView|WKWebView)$/) do |type|
  if type == "UIWebView"
    touch({marked: "uiwebview row"})
  else
    touch({marked: "wkwebview row"})
  end
  wait_for_view({marked: "H1 Header!"})
end

And(/^I scroll down to the first and last name text fields$/) do
  scroll_to(:up, "landing page", "Last name:", 5, true)
end

When(/^I touch the first name text field$/) do
  touch({type: "TextField", index: 0})
  wait_for_keyboard
  # Depending on the form factor, this might be a large animation
  # as the keyboard animates on and the UIWebView animates to put
  # the text fields in the middle of the visible rect.
  sleep(2.0)
end

Then(/^the first name text field has keyboard focus$/) do
  text_field = query({type: "TextField", index: 0}).first
  expect(text_field["has_keyboard_focus"]).to be_truthy
end

Then(/^I can type my first name$/) do
  enter_text("Clever")
  wait_for_text_in_view("Clever", {type: "TextField", index: 0})
end

Then(/^I clear my first name using the clear text route$/) do
  clear_text
  wait_for_text_in_view(nil, {type: "TextField", index: 0})
end


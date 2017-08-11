
Given(/^I am looking at the (UIWebView|WKWebView|SafariWebController)$/) do |type|
  if type == "UIWebView"
    touch({marked: "uiwebview row"})
  elsif type == "WKWebView"
    touch({marked: "wkwebview row"})
  else
    touch({marked: "safari web controller row"})
    @safari_controller = true
  end

  wait_for_view({id: "H1 Header!"})
end

And(/^I scroll down to the first and last name text fields$/) do
  if @safari_controller
    start_point = point_for_full_pan_start(:up, {type: "WebView"})
    end_point = point_for_full_pan_end(:up, {type: "WebView"})
    pan_between_coordinates(start_point, end_point)
    sleep(2.0)
  else
    scroll_to(:up, "landing page", "Last name:", 5, true)
  end
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


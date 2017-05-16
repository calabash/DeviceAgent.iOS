
Given(/^I am looking at the (UIWebView|WKWebView|SafariWebController)$/) do |type|
  if type == "UIWebView"
    touch({marked: "uiwebview row"})
  elsif type == "WKWebView"
    touch({marked: "wkwebview row"})
  else
    touch({marked: "safari web controller row"})
    @safari_controller = true
  end
  wait_for_view({marked: "H1 Header!"})
end

And(/^I scroll down to the first and last name text fields$/) do
  if @safari_controller
    start_point = point_for_full_pan_start(:up, {type: "WebView"})
    end_point = point_for_full_pan_end(:up, {type: "WebView"})
    pan_between_coordinates(start_point, end_point)
  else
    scroll_to(:up, "landing page", "Last name:", 5, true)
  end
end

Then(/^I type my first name$/) do
  touch({type: "TextField", index: 0})
  wait_for_keyboard
  # Depending on the form factor, this might be a large animation
  # as the keyboard animates on and the UIWebView animates to put
  # the text fields in the middle of the visible rect.
  sleep(2.0)
  enter_text("Clever")
  wait_for_text_in_view("Clever", {type: "TextField", index: 0})
end

Then(/^I clear my first name using the clear text route$/) do
  clear_text
  wait_for_text_in_view(nil, {type: "TextField", index: 0})
end



Given(/^I am looking at the (UIWebView|WKWebView|SafariWebController)$/) do |type|
  if ios_gte?("13.0")
    log_inline("Skip #{type} test since it doesn't work properly on iOS 13. It doesn't allow to get the content of TextField")
    skip_this_scenario
  end

  if type == "UIWebView"
    touch({marked: "uiwebview row"})
  elsif type == "WKWebView"
    touch({marked: "wkwebview row"})
  else
    touch({marked: "safari web controller row"})
    @safari_controller = true
  end

  wait_for_view({id: "H1 Header!", all: true})

  if @safari_controller
    if RunLoop::Environment.xtc?
      sleep(20.0)
    else
      sleep(4.0)
    end
  end
end

And(/^I scroll down to the first and last name text fields$/) do
  # Failing on iPhone 10 in Test Cloud.
  if @safari_controller
    start_point = point_for_full_pan_start(:up, {type: "WebView", all: true})
    end_point = point_for_full_pan_end(:up, {type: "WebView", all: true})

    if ["iphone 10r", "iphone 10s max"].include?(device_info["form_factor"])
      end_point[:y] = end_point[:y] + 100
    end

    pan_between_coordinates(start_point, end_point)
  else
    scroll_to(:up, "landing page", "Last name:", 5, true)
  end

  # Wait for scroll animation to stop
  sleep(4.0)

  # Scroll a little more for iPhone 4in
  if device_info["form_factor"] == "iphone 4in"
    start_point = point_for_small_pan_start(:up, {type: "WebView", all: true})
    end_point = point_for_small_pan_end(:up, {type: "WebView", all: true})
    pan_between_coordinates(start_point, end_point)
    sleep(4.0)
  end
end

When(/^I touch the first name text field$/) do
  touch({type: "TextField", index: 0, all: true})
  wait_for_keyboard
  # Depending on the form factor, this might be a large animation
  # as the keyboard animates on and the UIWebView animates to put
  # the text fields in the middle of the visible rect.
  sleep(1.0)
end

Then(/^the first name text field has keyboard focus$/) do
  text_field = query({type: "TextField", index: 0, all: true}).first
  expect(text_field["has_keyboard_focus"]).to be_truthy
end

Then(/^I can type my first name$/) do
  enter_text("Clever")
  sleep(1.0)
  wait_for_text_in_view("Clever", {type: "TextField", index: 0, all: true})
end

Then(/^I clear my first name using the clear text route$/) do
  clear_text
  wait_for_text_in_view(nil, {type: "TextField", index: 0, all: true})
  sleep(0.4)

  if device_info["ipad"]
    touch({marked: "Hide keyboard", type: "Button"})
  else
    touch({marked:"Done", type: "Button"})
  end

  wait_for_no_keyboard
  wait_for_animations
end

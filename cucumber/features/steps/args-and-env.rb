
And(/^I am looking at the Arguments page$/) do
  touch_tab("Misc")
  touch({marked: "arguments row"})
  wait_for_view({marked: "arguments page"})
  wait_for_animations
end

And(/^I am looking at the Environment page$/) do
  touch_tab("Misc")
  touch({marked: "environment row"})
  wait_for_view({marked: "environment page"})
  wait_for_animations
end

Then(/^I see the app was launched with the correct arguments$/) do
  wait_for_view({marked: "Language precedence: (da)"})
  wait_for_view({marked: "Preferred locale: da"})
  wait_for_view({marked: "The Calabus Driver is on the job!"})
end

Then(/^I see the app was launched with the correct environment$/) do

  # ENV declared in launch options
  wait_for_view({marked: "android row"})
  wait_for_text_in_view("0", {marked: "android row details"})
  wait_for_view({marked: "apple row"})
  wait_for_text_in_view("1", {marked: "apple row details"})

  if RunLoop::Environment.xtc?
    # ENV passed as arguments to uploader
    wait_for_view({marked: "ARG_FROM_UPLOADER_FOR_AUT"})
    wait_for_view({marked: "From-the-CLI-uploader!"})
  end
end


module TestApp
  module Pan

    def clear_pan_action_label
      @gestures.touch_mark("pan action")
      wait_for_pan_action_text("CLEARED")
    end

    def wait_for_pan_action_text(text)
      @waiter.wait_for_text_in_view(text, "pan action")
    end
  end
end

World(TestApp::Pan)

And(/^I am looking at the Pan Palette page$/) do
  @waiter.wait_for_view("pan page")
  @gestures.touch_mark("pan palette row")
  @waiter.wait_for_view("pan palette page")
  @waiter.wait_for_animations
end

Given(/^I am looking at the Drag and Drop page$/) do
  @gestures.tap_mark("drag and drop row")
  @waiter.wait_for_view("drag and drop page")
  @waiter.wait_for_animations
end

And(/^I can pan with (\d+) fingers?$/) do |fingers|
  clear_pan_action_label

  options = {
    :num_fingers => fingers.to_i,
    :duration => 0.5
  }

  if fingers.to_i > 3
    from_point = {:x => 160, :y => 80}
    to_point = {:x => 160, :y => 460}
  else
    from_point = {:x => 20, :y => 80}
    to_point = {:x => 300, :y => 460}
  end

  @gestures.pan_between_coordinates(from_point, to_point, options)

  wait_for_pan_action_text("Pan")
end

But(/^I cannot pan with 6 fingers$/) do
  options = {
    :num_fingers => 6,
    :duration => 0.5
  }

  from_point = {:x => 20, :y => 80}
  to_point = {:x => 300, :y => 460}

  expect do
    @gestures.pan_between_coordinates(from_point, to_point, options)
  end.to raise_error RunLoop::XCUITest::HTTPError,
                     /num_fingers must be between 1 and 5, inclusive/
end

And(/^I can pan (quickly|slowly)$/) do |speed|
  clear_pan_action_label

  if speed == "quickly"
    duration = 0.1
  else
    duration = 1.0
  end

  options = {
    :duration => duration
  }

  from_point = {:x => 160, :y => 80}
  to_point = {:x => 160, :y => 460}
  @gestures.pan_between_coordinates(from_point, to_point, options)

  wait_for_pan_action_text("Pan")
end

Then(/^I can drag the red box to the right well$/) do
  # TODO Figure out how to query for these elements so we can test in other
  # orientations and form factors.
  @gestures.rotate_home_button_to(:bottom)

  from_point = {:x => 83.5, :y => 124}
  to_point = {:x => 105.5, :y => 333.5}
  @gestures.pan_between_coordinates(from_point, to_point)

  # TODO figure out how to assert the drag and drop happened.
end

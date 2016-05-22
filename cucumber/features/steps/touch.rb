module UnitTestApp
  module TouchGestures
    def wait_for_gesture_text(text, mark="gesture performed")
      result = @waiter.wait_for_view(mark)

      candidates = [result["value"],
                    result["label"]]
      match = candidates.any? do |elm|
        elm == text
      end
      if !match
        @waiter.fail(%Q[
Expected to find '#{text}' as a 'value' or 'label' in

#{JSON.pretty_generate(result)}

])
      end
    end
  end
end

World(UnitTestApp::TouchGestures)

Then(/^I can tap the screen by coordinate$/) do
  @gestures.tap(50, 50)
  wait_for_gesture_text("Tap")
end

Then(/^I can tap with two fingers by coordinate$/) do
  @gestures.two_finger_tap(100, 100)
  wait_for_gesture_text("Two-finger Tap")
end

And(/^I clear the touch action label$/) do
  @gestures.tap_mark("touch action")
  wait_for_gesture_text("CLEARED", "touch action")
end

Then(/^I double tap the little button$/) do
  @gestures.double_tap_mark("double tap")
  wait_for_gesture_text("double tap", "touch action")
end

Then(/^I tap the little button$/) do
  @gestures.tap_mark("touch")
  wait_for_gesture_text("touch", "touch action")
end


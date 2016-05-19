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

And(/^I can see the buttons in the action box$/) do
  [
    "double tap",
    "tap",
    "long press",
    "two finger tap",
    "triple tap",
    "two finger long press",
    "three finger tap",
    "two finger double tap"
  ].each do |mark|
    @waiter.wait_for_view(mark)
  end
end

And(/^I can see the button action label$/) do
  @waiter.wait_for_view("touch action")
end

Then(/^I double tap the button$/) do
  @gestures.double_tap_mark("double tap")
  wait_for_gesture_text("double tap", "touch action")
end


module UnitTestApp
  module TouchGestures
    def wait_for_gesture_text(text, mark="gesture performed")
      result = @waiter.wait_for_view(mark)
      expect(result["value"]).to be == text
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
  @waiter.wait_for_view("action label")
end

Then(/^I double tap the button$/) do
  @gestures.double_tap_mark("double tap")
  wait_for_gesture_text("double tap", "action label")
end


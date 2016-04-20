module UnitTestApp
  module TouchGestures

    def touch(x, y)
      @device_agent.tap_coordinate(50, 50)
    end

    def two_finger_touch(x, y)
      @device_agent.perform_coordinate_gesture("two_finger_tap", x, y)
    end

    def wait_for_gesture_text(text)
      result = @waiter.wait_for_view("gesture performed")
      expect(result["value"]).to be == text
    end
  end
end

World(UnitTestApp::TouchGestures)

Then(/^I can tap the screen by coordinate$/) do
  touch(50, 50)
  wait_for_gesture_text("Tap")
end

Then(/^I can tap with two fingers by coordinate$/) do
  two_finger_touch(100, 100)
  wait_for_gesture_text("Two-finger Tap")
end


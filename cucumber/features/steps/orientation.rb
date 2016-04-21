
module UnitTestApp
  module Orientation

    def rotate_and_expect(position)
      symbol = position.to_sym
      json = @device_agent.rotate_home_button_to(symbol)
      orientation = json["orientation"]

      if [:top, :up].include?(symbol)
        # We need runtime info about the device under test.
        # Specifically, is it an iPhone 6* device; they don't
        # support upside down orientations.
        RunLoop.log_warn("Skipping test because upside down orientation is not supported on all devices")
      else
        expected = expected_position(position)
        expect(orientation).to be == expected
      end
    end

    def expected_position(position)
      symbol = position.to_sym
      case symbol
      when :top, :up
        2
      when :bottom, :down
        1
      when :right
        3
      when :left
        4
      else
        raise ArgumentError, %Q[
Expected '#{position}' to be [:top, :up, :bottom, :down, :left, :right]
]
      end
    end
  end
end

World(UnitTestApp::Orientation)

Then(/^I rotate the device so the home button is on the (top|bottom|left|right)$/) do |position|
  rotate_and_expect(position)
end


module UnitTestApp
  module Volume

    def current_volume
      result = wait_for_view({marked: "current volume"})

      candidates = [result["value"], result["label"]]

      volume = candidates.detect do |text|
        !text.nil? && text != ""
      end

      volume.to_f
    end

    def expect_volume_gt(volume)
      current = current_volume
      if device_info["simulator"] == true
        log_inline("Changing the volume is not supported on iOS Simulators")
        expect(current).to be == volume
      else
        if current <= volume
          fail(%Q[
Expected volume to be larger that previous value:

   current: #{current}
  previous: #{volume}

])
        end
      end
    end


    def expect_volume_lt(volume)
      current = current_volume

      if device_info["simulator"] == true
        log_inline("Changing the volume is not supported on iOS Simulators")
        expect(current).to be == volume
      else
        if current >= volume
          fail(%Q[
Expected volume to be smaller that previous value:

   current: #{current}
  previous: #{volume}

])
        end
      end
    end

    def volume_up
      previous = current_volume
      change_volume("up")
      expect_volume_gt(previous)
    end

    def volume_down
      previous = current_volume
      change_volume("down")
      expect_volume_lt(previous)
    end
  end
end

World(UnitTestApp::Volume)

And(/^I am looking at the Volume page$/) do
  touch_tab("Misc")
  touch({marked: "volume row"})
  wait_for_view({marked: "volume page"})
  wait_for_animations
end

Then(/^I can turn the volume (up|down)$/) do |direction|
  if direction == "up"
    volume_up
  else
    volume_down
  end
end

And(/^sending an invalid volume direction raises an error$/) do
  expect do
    change_volume("bad")
  end.to raise_error RunLoop::DeviceAgent::Client::HTTPError,
                     /Invalid volume direction. Please specify/
end

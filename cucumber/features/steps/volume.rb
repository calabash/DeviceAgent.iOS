module UnitTestApp
  module Volume

    def current_volume
      result = @waiter.wait_for_view("current volume")

      candidates = [result["value"], result["label"]]

      volume = candidates.detect do |text|
        !text.nil? && text != ""
      end

      volume.to_f
    end

    def expect_volume_gt(volume)
      current = current_volume
      if @gestures.device_info["simulator"] == true
        message = "Changing the volume is not supported on iOS Simulators"
        colored = RunLoop::Color.blue(message)
        $stdout.puts("    #{colored}")
        expect(current).to be == volume
      else
        if current <= volume
          fail(%Q[
Expected volume to be larger that previous value:

  currrent: #{current}
  previous: #{volume}

])
        end
      end
    end


    def expect_volume_lt(volume)
      current = current_volume

      if @gestures.device_info["simulator"] == true
        message = "Changing the volume is not supported on iOS Simulators"
        colored = RunLoop::Color.blue(message)
        $stdout.puts("    #{colored}")
        expect(current).to be == volume
      else
        if current >= volume
          fail(%Q[
Expected volume to be smaller that previous value:

  currrent: #{current}
  previous: #{volume}

])
        end
      end
    end

    def volume_up
      previous = current_volume
      @gestures.change_volume("up")
      expect_volume_gt(previous)
    end

    def volume_down
      previous = current_volume
      @gestures.change_volume("down")
      expect_volume_lt(previous)
    end
  end
end

World(UnitTestApp::Volume)

Then(/^I can turn the volume (up|down)$/) do |direction|
  if direction == "up"
    volume_up
  else
    volume_down
  end
end

And(/^sending an invalid volume direction raises an error$/) do
  expect do
    @gestures.change_volume("bad")
  end.to raise_error RunLoop::DeviceAgent::Client::HTTPError,
                     /Invalid volume direction. Please specify/
end

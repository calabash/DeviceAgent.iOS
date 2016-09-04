module DeviceAgent
  module Shared

    @@app_ready = nil

    def wait_for_app
      return true if DeviceAgent::Shared.class_variable_get(:@@app_ready)

      if device_info["simulator"]
        timeout = 8
      else
        timeout = 20
      end

      wait_options = {:timeout => timeout}

      ["Touch", "Pan", "Rotate/Pinch", "Misc", "Tao"].each do |mark|
        wait_for_view({marked: mark}, wait_options)
      end

      if RunLoop::Environment.ci?
        delay = 15
      else
        delay = 5
      end

      RunLoop.log_debug("Adding #{delay} second sleep; app is not ready to receive touches?")
      sleep(delay)

      DeviceAgent::Shared.class_variable_set(:@@app_ready, true)
    end
  end
end

World(DeviceAgent::Shared)

Given(/^the app has launched$/) do
  wait_for_app
  rotate_home_button_to(:down)
end

Given(/^I am looking at the (Touch|Pan|Rotate\/Pinch|Misc|Tao) tab$/) do |tabname|
  touch({marked: tabname})
  mark = "#{tabname.downcase} page"
  wait_for_view({marked: mark})
end

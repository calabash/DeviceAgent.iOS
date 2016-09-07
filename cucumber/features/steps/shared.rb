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

      RunLoop.log_debug("Waiting for app to start responding to touches")

      start = Time.now

      timeout = 30
      message = %Q[Waited #{timeout} second for the app to start responding to touches.]
      query = {:text => "That was touching."}
      touch_count = 0
      wait_for(message, timeout: timeout) do
        touch({marked: "gesture performed"})
        touch_count = touch_count + 1
        !query(query).empty?
        sleep(0.4)
      end

      RunLoop.log_debug("Waited #{Time.now - start} seconds for the app to respond to touches")
      RunLoop.log_debug("Performed #{touch_count} touches while waiting")

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

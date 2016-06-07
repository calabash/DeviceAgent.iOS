module DeviceAgent
  module Shared

    @@app_ready = nil

    def wait_for_app
      return true if DeviceAgent::Shared.class_variable_get(:@@app_ready)

      ["Touch", "Pan", "Rotate/Pinch", "Misc", "Tao"].each do |mark|
        @waiter.wait_for_view(mark)
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
end

Given(/^I am looking at the (Touch|Pan|Rotate\/Pinch|Misc|Tao) tab$/) do |tabname|
  @gestures.tap_mark(tabname)
  mark = "#{tabname.downcase} page"
  @waiter.wait_for_view(mark)
end


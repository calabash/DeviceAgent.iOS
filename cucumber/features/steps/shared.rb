module DeviceAgent
  module Shared

    @@app_ready = nil

    def wait_for_app
      return true if DeviceAgent::Shared.class_variable_get(:@@app_ready)

      if @gestures.device_info["simulator"]
        timeout = 8
      else
        timeout = 20
      end

      wait_options = {:timeout => timeout}

      ["Touch", "Pan", "Rotate/Pinch", "Misc", "Tao"].each do |mark|
        @waiter.wait_for_view(mark, wait_options)
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

Given(/^I am looking at the Drag and Drop page$/) do
  @gestures.tap_mark("drag and drop row")
  @waiter.wait_for_view("drag and drop page")
end


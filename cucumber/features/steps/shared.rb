module DeviceAgent
  module Shared

    @@app_ready = nil

    def wait_for_app(option=nil)
      return true if DeviceAgent::Shared.class_variable_get(:@@app_ready)

      if device_info["simulator"]
        timeout = 20
      else
        timeout = 20
      end

      wait_options = {:timeout => timeout}

      ["Touch", "Pan", "Rotate/Pinch", "Misc", "Tao"].each do |mark|
        wait_for_view({marked: mark}, wait_options)
      end

      if option != :skip_touch_check
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
      end

      DeviceAgent::Shared.class_variable_set(:@@app_ready, true)
    end

    def touch_tab(tabname)
      if keyboard_visible?
        if !query({marked: "Done", type: "Button"}).empty?
          touch({marked:"Done", type: "Button"})
        elsif !query({marked: "dismiss text view keyboard"}).empty?
          touch({marked: "dismiss text view keyboard"})
        elsif !query({marked: "Search", type: "Button"}).empty?
          touch({marked: "Search", type: "Button"})
        elsif !query({marked: "Hide keyboard", type: "Button"}).empty?
          touch({marked: "Hide keyboard", type: "Button"}).empty?
        else
          raise "Keyboard is showing, but there is no way to dismiss it"
        end
      end

      wait_for_animations

      touch({marked: tabname})
      wait_for_animations
      # Get back to the root view controller of the tab.
      if tabname == "Pan" || tabname == "Misc"
        touch({marked: tabname})
        wait_for_animations
      end
      mark = "#{tabname.downcase} page"
      wait_for_view({marked: mark})
    end

    def ios_version
      RunLoop::Version.new(device_info["ios_version"])
    end

    def ios_gte?(version)
      right_hand_side = version
      if version.is_a?(String)
        right_hand_side = RunLoop::Version.new(version)
      end
      ios_version >= right_hand_side
    end

    def xcodebuild_version
      version = server_version["xcode_version"]
      major = version[0,2]
      minor = version[2]
      patch = version[3]
      RunLoop::Version.new("#{major}.#{minor}.#{patch}")
    end

    def device_agent_built_with_xcode_gte_9?
      xcodebuild_version >= RunLoop::Version.new("9.0.0")
    end

    def device_agent_built_with_xcode_gte_93?
      xcodebuild_version >= RunLoop::Version.new("9.3.0")
    end

    def device_agent_built_with_xcode_gte_11?
      xcodebuild_version >= RunLoop::Version.new("11.0")
    end

    def iphone_x?
      device_info["form_factor"] == "iphone 10"
    end
  end
end

World(DeviceAgent::Shared)

Given(/^the app has launched$/) do
  wait_for_app
  rotate_home_button_to(:down)
end

Given(/^I am looking at the (Touch|Pan|Rotate\/Pinch|Misc|Tao) tab$/) do |tabname|
  touch_tab(tabname)
end

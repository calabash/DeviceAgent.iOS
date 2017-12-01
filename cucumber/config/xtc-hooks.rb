require "run_loop"

module DeviceAgent
  class Launcher
    require "singleton"
    include Singleton

    attr_accessor :device_agent
    attr_accessor :first_launch

    def self.remove_module(mod)
      ignore = [:screenshot, :relaunch, :init_request, :stop]
      begin
        mod.instance_methods.each do |method_name|
          if ignore.include?(method_name)
            # ignore
          elsif method_name.to_s.start_with?("xtc")
            # ignore
          else
            mod.send(:undef_method, method_name)
          end
        end
      rescue => e
        $stdout.puts "Caught #{e} while undefining methods in mod; ignoring"
        $stdout.flush
      end
    end

    def initialize
      @first_launch = true
    end

    def running?
      return false if !device_agent
      device_agent.running?
    end

    def terminate_aut_before_test?(scenario)
      # For these tests we want to default to _always_ shutting down the
      # AUT when POST /session is called. This is the opposite of the
      # default behavior of run-loop.
      if scenario.tags.detect { |tag| tag.name == "@keep_app_running" }
        # The default value in run-loop
        false
      else
        # Kill the AUT when POST /session is called
        true
      end
    end
  end
end

Before("@reset_device") do |scenario|
  ENV["RESET_BETWEEN_SCENARIOS"] = "1"
end

Before("@keep_app_running") do |scenario|
  # Force RunLoop.run options to re-eval'd
  DeviceAgent::Launcher.instance.first_launch = true
end

Before do |scenario|
  launcher = DeviceAgent::Launcher.instance


  options = {
    :args => ["-AppleLanguages", "(da)",
              "-AppleLocale", "da",
              "CALABUS_DRIVER"],
    :env => {
      "APPLE" => true,
      "ANDROID" => false
    },

    # Keep this as true.
    #
    # In this context, this means - when the tests
    # first start, shutdown any running DeviceAgent
    #
    # See the guard below: RunLoop.run(options) is
    # only called on first launch or when the
    # DeviceAgent is not running.
    :shutdown_device_agent_before_launch => true,

    # The default in run-loop is keep the AUT running if it
    # is already running.  UITest and Calabash users can call
    # `calabash_exit` in an After hook to shutdown the AUT.
    # This test suite does not use calabash at all.  The default
    # behavior for this test suite is always shutdown a running
    # AUT so every test starts with the app freshly launched.
    :terminate_aut_before_test => true
  }

  if launcher.first_launch || !launcher.running?
    require "calabash-cucumber/launcher"
    cal_launcher = Calabash::Cucumber::Launcher.new
    cal_launcher.relaunch(options)

    client = cal_launcher.automator.send(:client)
    DeviceAgent::Automator.client = client
    launcher.device_agent = client
    launcher.first_launch = false
  else
    DeviceAgent::Automator.client = launcher.device_agent
  end
end

After("@keyboard") do |scenario|
  if keyboard_visible?
    if !query({marked: "Done", type: "Button"}).empty?
      touch({marked:"Done", type: "Button"})
    elsif !query({marked: "dismiss text view keyboard"}).empty?
      touch({marked: "dismiss text view keyboard"})
    elsif !query({marked: "Search", type: "Button"}).empty?
      touch({marked: "Search", type: "Button"})
    else
      raise "Keyboard is showing, but there is no way to dismiss it"
    end
    wait_for_animations
  end
end

After("@search_bar") do |scenario|
  result = query({marked: "Cancel"})
  if !result.empty?
    touch({marked: "Cancel"})
    wait_for_animations
  end
end

After do |scenario|
  # Restart the app if a Scenario fails
  if scenario.failed?
    DeviceAgent::Launcher.instance.first_launch = true
  end
end

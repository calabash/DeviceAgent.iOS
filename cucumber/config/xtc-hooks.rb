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
  end
end

Before("@reset_device") do |scenario|
  ENV["RESET_BETWEEN_SCENARIOS"] = "1"
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

    # Never terminate the DeviceAgent on Test Cloud
    :shutdown_device_agent_before_launch => false,

    # We want the AUT to never relaunch unless there is a failure.
    :terminate_aut_before_test => true
  }

  aut_running = false
  client = DeviceAgent::Automator.client
  if client && client.send(:app_running?, "sh.calaba.TestApp")
    aut_running = true
  end

  if launcher.first_launch || !aut_running
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
    elsif !query({marked: "Hide keyboard", type: "Button"}).empty?
      touch({marked: "Hide keyboard", type: "Button"}).empty?
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
    DeviceAgent::Shared.class_variable_set(:@@app_ready, nil)
    client = DeviceAgent::Automator.client
    if client && client.send(:app_running?, "sh.calaba.TestApp")
      client.send(:terminate_app, "sh.calaba.TestApp")
      sleep(1.0)
      if client.send(:app_running?, "sh.calaba.TestApp")
        raise "sh.calaba.TestApp is running!?!"
      end
    end
  end
end

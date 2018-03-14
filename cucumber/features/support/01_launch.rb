
module Calabash
  class Launcher
    require "singleton"
    include Singleton

    attr_accessor :device_agent
    attr_accessor :first_launch

    def initialize
      @first_launch = true
    end

    def running?
      return false if !device_agent
      device_agent.running?
    end

    def shutdown_running_device_agent?(scenario)
      return false if RunLoop::Environment.xtc?
      names = scenario.tags.map { |tag| tag.name }
      !names.include?("@keep_device_agent_running")
    end

    def xcode
      @xcode ||= RunLoop::Xcode.new
    end

    def simctl
      @simctl ||= RunLoop::Simctl.new
    end

    def instruments
      @instruments ||= RunLoop::Instruments.new
    end

    def device
      @device ||= RunLoop::Device.detect_device({},
                                                self.xcode,
                                                self.simctl,
                                                self.instruments)
    end

    def app
      @app ||= lambda do
        dir = File.expand_path(File.dirname(__FILE__))
        path = File.expand_path(File.join(dir, "..", "..", "..",
                                          "Products", "app",
                                          "TestApp", "TestApp.app"))
        if !File.exist?(path)
          $stderr.puts "Will build TestApp"
          Bundler.with_clean_env do
            Dir.chdir("..") do
              system("make test-app")
            end
          end
        end
        path
      end.call
    end
  end
end

Before("@simulator") do |scenario|
  device = Calabash::Launcher.instance.device
  if device.physical_device?
    raise "This scenario does not run on physical devices"
    exit 1
  end
end

Before("@reset_device") do |scenario|
  device = Calabash::Launcher.instance.device
  if device.simulator?
    RunLoop::CoreSimulator.erase(device)
    RunLoop.log_info2("Erasing simulator!")
    RunLoop::CoreSimulator.new(device, nil).launch_simulator
  else
    raise "Cannot reset a physical device"
    exit 1
  end
end

Before do |scenario|
  launcher = Calabash::Launcher.instance

  args = ["-AppleLanguages", "(da)", "-AppleLocale", "da", "CALABUS_DRIVER"]

  if !RunLoop::Environment.xtc?
    args.push("FINGERTIPS")
  end

  options = {
    :device => launcher.device.udid,
    :xcode => launcher.xcode,
    :simctl => launcher.simctl,
    :instruments => launcher.instruments,
    :args => args,
    :env => {
      "APPLE" => true,
      "ANDROID" => false
    },

    :app => launcher.app,

    # Maintainers only.
    #:cbx_launcher => :xcodebuild,

    # Keep this as true.
    #
    # In this context, this means - when the tests
    # first start, shutdown any running DeviceAgent
    #
    # See the guard below: RunLoop.run(options) is
    # only called on first launch or when the
    # DeviceAgent is not running.
    #
    # On Test Cloud, shutdown will raise an error.
    #
    # If you need to keep DeviceAgent running regardless,
    # tag Scenario with @keep_device_agent_running
    shutdown_device_agent_before_launch:
    launcher.shutdown_running_device_agent?(scenario),

    # The default in run-loop is keep the AUT running if it
    # is already running.  UITest and Calabash users can call
    # `calabash_exit` in an After hook to shutdown the AUT.
    # This test suite does not use calabash at all.  The default
    # behavior for this test suite is always shutdown a running
    # AUT so every test starts with the app freshly launched.
    :terminate_aut_before_test => true
  }

  if launcher.first_launch
    device = launcher.device
    # See the bin/test/jmoody scripts.
    if ENV["ERASE_SIM_BEFORE"] == "1" && device.simulator?
      RunLoop.log_info2("Erasing simulator!")
      RunLoop::CoreSimulator.erase(device)
    end
  end

  if launcher.first_launch || !launcher.running?
    # See bin/test/jmoody scripts.
    client = RunLoop.run(options)
    DeviceAgent::Automator.client = client
    launcher.device_agent = client
    launcher.first_launch = false
  else
    DeviceAgent::Automator.client = launcher.device_agent
  end
end

# TODO:  Scenario: Client#shutdown
# TODO:  Feature: Client#launch_other_app
# TODO:  Feature: SpringBoard alerts
# TODO:    Scenario: All alerts at once
# TODO:  Feature: SpringBoard views
# TODO:  Feature: Locale
# TODO:  Feature: Location

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

After("@shutdown_after") do |scenario|
  DeviceAgent::Automator.shutdown
end

After("@term") do |scenario|
  Calabash::Launcher.instance.first_launch = true
  DeviceAgent::Shared.class_variable_set(:@@app_ready, nil)
end

After do |scenario|
  # See bin/test/jmoody scripts.
  on_scenario_failure = ENV["ON_SCENARIO_FAILURE"]
  if on_scenario_failure
    on_scenario_failure = on_scenario_failure.to_sym
  end

  after = on_scenario_failure || :default

  case after
    when :default
      # Restart the app if a Scenario fails
      if scenario.failed?
        Calabash::Launcher.instance.first_launch = true
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
    when :shutdown
      begin
        DeviceAgent::Automator.shutdown
      rescue => e
        RunLoop.log_error("#{e}")
        exit!(1)
      end
    when :exit
      if scenario.failed?
        exit!(1)
      end
    when :pry
      if scenario.failed?
        binding.pry
      end
    else
      # Do nothing
  end
end

at_exit do
  if !RunLoop::Environment.xtc?
    # See bin/test/jmoody scripts.
    if ENV["QUIT_AUT_AFTER_CUCUMBER"] == "1"
      DeviceAgent::Automator.shutdown
    end
  end
end

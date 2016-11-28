
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
        if ENV["APP"].nil? || ENV["APP"] == ""
          dir = File.expand_path(File.dirname(__FILE__))
          path = File.expand_path(File.join(dir, "..", "..", "..",
                                            "Products", "app",
                                            "TestApp", "TestApp.app"))
          if File.exist?(path)
            path
          else
            $stderr.puts "APP is not defined and could not find app at:"
            $stderr.puts ""
            $stderr.puts "  #{path}"
            $stderr.puts ""
            $stderr.puts "You have some options:"
            $stderr.puts ""
            $stderr.puts " 1. Run against the TestApp"
            $stderr.puts "   $ (cd .. && make test-app)"
            $stderr.puts "   $ be cucumber"
            $stderr.puts ""
            $stderr.puts "2. Run against another app on the simulator."
            $stderr.puts "   $ APP=/path/to/My.app be cucumber"
            $stderr.puts ""
            $stderr.puts "3. Run against an app installed on the simulator."
            $stderr.puts "   $ APP=com.example.MyApp be cucumber"
            $stderr.puts ""
            $stderr.puts "4. Run against an app install on a device. The device target can be"
            $stderr.puts "   a UDID or the name of the device."
            $stderr.puts "   $ APP=com.example.MyApp DEVICE_TARGET=< udid or name> be cucumber"
            $stderr.puts ""
            $stderr.puts "Exiting...Goodbye."
            $stderr.flush
            exit 1
          end
        else
          ENV["APP"]
        end
      end.call
    end
  end
end

Before do |scenario|
  launcher = Calabash::Launcher.instance
  options = {
    :device => launcher.device.udid,
    :xcode => launcher.xcode,
    :simctl => launcher.simctl,
    :instruments => launcher.instruments,
    :app => launcher.app,
    # Maintainers only.
    #:cbx_launcher => :xcodebuild,

    # Keep this as true.
    #
    # In this context, these means - when the tests
    # first start, shutdown any running DeviceAgent
    #
    # See the guard below: RunLoop.run(options) is
    # only called on first launch or when the
    # DeviceAgent is not running.
    :shutdown_device_agent_before_launch => true
  }

  if launcher.first_launch || !launcher.running?
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
# TODO:  Feature: WebViews

After("@keyboard") do |scenario|
  if keyboard_visible?
    touch({marked:"Done"})
    wait_for_animations
  end
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
  # See bin/test/jmoody scripts.
  if ENV["QUIT_AUT_AFTER_CUCUMBER"] == "1"
    DeviceAgent::Automator.shutdown
  end
end

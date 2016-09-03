
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
      @device ||= RunLoop::Device.detect_device({}, self.xcode, self.simctl, self.instruments)
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
    :automator => :device_agent,
    #:cbx_launcher => :xcodebuild,

    # Keep this as true.  The Launcher singleton ensures
    # that the DeviceAgent-Runner is launched only once
    # on physical devices.
    :shutdown_device_agent_before_launch => true
  }

  if launcher.first_launch || !launcher.running?
    @device_agent = RunLoop.run(options)
    @waiter = DeviceAgent::Wait.new(@device_agent)
    @gestures = DeviceAgent::Gestures.new(@waiter)
    launcher.device_agent = @device_agent
    launcher.first_launch = false
  else
    @device_agent = launcher.device_agent
    @waiter = DeviceAgent::Wait.new(@device_agent)
    @gestures = DeviceAgent::Gestures.new(@waiter)
  end
end

After do |scenario|
  # Restart if a Scenario fails.
  if scenario.failed?
    Calabash::Launcher.instance.first_launch = true
  end
end



module Calabash
  class Launcher
    require "singleton"
    include Singleton

    attr_accessor :device_agent

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
          path = File.expand_path(File.join("..", "Products", "app", "UnitTestApp", "UnitTestApp.app"))

          if File.exist?(path)
            path
          else
            $stderr.puts "APP is not defined and could not find app at:"
            $stderr.puts ""
            $stderr.puts "  #{path}"
            $stderr.puts ""
            $stderr.puts "You have some options:"
            $stderr.puts ""
            $stderr.puts " 1. Run against the UnitTestApp"
            $stderr.puts "   $ (cd .. && make unit-app)"
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
    :xcuitest => true,
    :xcode => launcher.xcode,
    :simctl => launcher.simctl,
    :instruments => launcher.instruments,
    :app => launcher.app
  }

  @device_agent = RunLoop.run(options)
  @waiter = DeviceAgent::Wait.new(@device_agent)
  launcher.device_agent = launcher
end

After do |scenario|

end


#!/usr/bin/env ruby

# Usage
#
# A physical device must be attached via USB.
#
# Before testing, run:
#
# $ make clean
#
# Command line
#
# $ make ipa-agent; bin/test/install-cbx-runner-ipa.rb
#
# Xcode
#
# 1. Select the XCUITestDriver scheme
# 2. Select the target physical device
# 3. Shift + Option + Command + K (deep clean)
# 4. Shift + Command + U (build for testing)
# 5. $ bin/test/install-cbx-runner-ipa.rb

require "run_loop"

options = {:device => "device"}
xcode = RunLoop::Xcode.new
simctl = RunLoop::Simctl.new
instruments = RunLoop::Instruments.new

begin
  device = RunLoop::Device.detect_device(options,
                                         xcode,
                                         simctl,
                                         instruments)
rescue StandardError => e
  puts %Q[Rescued error:

#{e.message}

]
  exit 1
end


if device.simulator?
  puts "Did not find a physical device connected via USB"
  exit 1
end

udid = device.udid

args = [
  "-u", udid,
  "--install",
  File.join("Products", "ipa", "DeviceAgent", "CBX-Runner.ipa")
]

system("ideviceinstaller", *args)


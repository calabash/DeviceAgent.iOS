#!/usr/bin/env ruby

require "run_loop"

working_dir = File.expand_path(File.join(File.dirname(__FILE__), "..", ".."))

# Load the correct CoreSimulatorService
RunLoop::Simctl.new

xcode = RunLoop::Xcode.new
default_sim_name = RunLoop::Core.default_simulator
default_sim = RunLoop::Device.device_with_identifier(default_sim_name)
sim_udid = default_sim.udid

RunLoop::CoreSimulator.quit_simulator
RunLoop::CoreSimulator.erase(default_sim)

core_sim = RunLoop::CoreSimulator.new(default_sim, nil, {:xcode => xcode})
core_sim.launch_simulator

args =
      [
        "xcrun",
        "xcodebuild",
        "test",
        "-SYMROOT=build/alerts-ui-tests",
        "-derivedDataPath", "build/alerts-ui-tests",
        "-workspace", "DeviceAgent.xcworkspace",
        "-scheme", "Dismiss",
        "-destination", "id=#{sim_udid}",
        "-sdk", "iphonesimulator",
        "-configuration", "Debug",
        "CLANG_ENABLE_CODE_COVERAGE=NO",
        "OTHER_CFLAGS=-Xclang -Wno-switch"    
      ]

env = { "COMMAND_LINE_BUILD" => "1",
        "DEVELOPER_DIR" => xcode.developer_dir }

Process.exec(env, *args)
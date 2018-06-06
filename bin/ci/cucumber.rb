#!/usr/bin/env ruby

require "luffa"
require "bundler"

this_dir = File.expand_path(File.dirname(__FILE__))
working_directory = File.expand_path(File.join(this_dir, "..", "..", "cucumber"))

Bundler.with_clean_env do
  Dir.chdir(working_directory) do

    system("bundle update")

    require "run_loop"
    require "fileutils"

    hash = RunLoop::Shell.run_shell_command(["bundle", "show", "run_loop"],
                                            {log_cmd: true})

    target = File.join(hash[:out].strip,
                       "lib", "run_loop", "device_agent",
                       "app", "DeviceAgent-Runner.app")
    source = File.join("..", "Products", "app", "DeviceAgent",
                       "DeviceAgent-Runner.app")

    FileUtils.rm_rf(target)
    FileUtils.cp_r(source, target)

    target = "#{target}.zip"
    source = "#{source}.zip"

    FileUtils.rm_rf(target)
    FileUtils.cp(source, target)

    FileUtils.rm_rf("reports")
    FileUtils.mkdir_p("reports")

    # Load the correct CoreSimulatorService
    RunLoop::Simctl.new
    RunLoop::CoreSimulator.terminate_core_simulator_processes

    env = {
       "DEVELOPER_DIR" => RunLoop::Xcode.new.developer_dir
    }

    args = [
     "bundle", "exec",
     "cucumber", "-p", "default",
     "-f", "json", "-o", "reports/cucumber.json",
     "-f", "junit", "-o", "reports/junit",
     "-f", "pretty"
		]


    RunLoop.log_unix_cmd(args.join(" "))
    system(env, *args)
  end
end

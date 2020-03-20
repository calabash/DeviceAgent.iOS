#!/usr/bin/env ruby

this_dir = File.expand_path(File.dirname(__FILE__))
working_directory = File.expand_path(File.join(this_dir, "..", "..", "cucumber"))

require "bundler"

Bundler.with_clean_env do
  Dir.chdir(working_directory) do

    system("bundle update")

    require "run_loop"
    require "fileutils"

    hash = RunLoop::Shell.run_shell_command(["bundle", "info", "--path", "run_loop"],
                                            {log_cmd: true})
    lines = File.join(hash[:out].strip)
    last_line = lines.split("\n")[-1]
    target = File.join(last_line,
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
    Process.exec(env, *args)
  end
end

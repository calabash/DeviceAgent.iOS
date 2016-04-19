#!/usr/bin/env ruby

require "luffa"
require "bundler"

this_dir = File.expand_path(File.dirname(__FILE__))
working_directory = File.expand_path(File.join(this_dir, "..", "..", "cucumber"))

Bundler.with_clean_env do
  Dir.chdir(working_directory) do

    system("bundle update")

    require "run_loop"

    FileUtils.rm_rf("reports")
    FileUtils.mkdir_p("reports")

    RunLoop::CoreSimulator.terminate_core_simulator_processes

    cmd = "bundle exec cucumber -p default --format json -o reports/cucumber.json"

    RunLoop.log_unix_cmd(cmd)
    cmd = cmd.split(" ")
    system(*cmd)
  end
end


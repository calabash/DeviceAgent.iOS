#!/usr/bin/env ruby
require 'awesome_print'
require 'colorize'
require 'pry'
require 'run_loop'
require_relative 'helpers'
require_relative 'localization_storage'

xcode = RunLoop::Xcode.new

def collect_localization_dictionary(dir_path)
    dict = {}
    Dir.glob("#{dir_path}/*.strings") do |file_path|
        pairs = read_strings(file_path)
        dict.merge!(pairs)
    end

    dict
end

def find_framework(root_path, framework_name)
    found = Dir.glob("#{root_path}/**/#{framework_name}")
    return nil if found.empty?

    raise "More than 1 occurrence of '#{framework_name}' is found" if found.length > 1

    found[0]
end

storage = LocalizationStorage.new('results/report.json')
target_frameworks = read_json('frameworks.json')
languages = read_json('languages.json')

target_frameworks.each do |framework|
    puts "Scan framework '#{framework['name']}'".green
    framework_path = find_framework(xcode.core_simulator_dir, framework['name'])

    unless framework_path && Dir.exist?(framework_path)
        puts "Skip '#{framework['name']}' since it was not found".red
        next
    end

    puts "Found on path '#{framework_path}'"

    available_languages = languages.select { |language| Dir.exist?(File.join(framework_path, language))}
    skipped_languages = languages - available_languages
    puts "Available languages: #{available_languages}"
    puts "Skipped languages: #{skipped_languages}".yellow unless skipped_languages.empty?

    available_languages.each do |language|
        # for debug purpose
        # next unless language.start_with? 'ru'
        language_path = File.join(framework_path, language)

        dict = collect_localization_dictionary(language_path)

        # pick the necessary constants
        framework['values'].each do |item|
            title = item['title']
            button = item['button']

            puts "Unknown button constant '#{button}'".yellow if button && !dict[button]

            if dict[title]
                storage.add_entry(language, dict[title], dict[button])
            else
                puts "Unknown alert constant '#{title}'".red
            end
        end

        # debug info
        if ENV['DEBUG']
            report_path = "reports/#{framework['name']}.#{language}.json"
            save_to_json_file(report_path, dict)
        end
    end
end

# save updated database to the local file
storage.save

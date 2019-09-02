#!/usr/bin/env ruby
require 'awesome_print'
require 'pry'
require 'run_loop'
require_relative 'helpers'
require_relative 'strings_parser'
require_relative 'localization_storage'

xcode = RunLoop::Xcode.new
private_frameworks_dir = xcode.core_simulator_dir + '/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/'

def collect_localization_dictionary(dir_path)
    dict = {}
    Dir.glob("#{dir_path}/*.strings") do |file_path|
        pairs = PlistParser.parse(file_path)
        dict.merge!(pairs)
    end

    dict
end

storage = LocalizationStorage.new('results/report.json')
target_frameworks = read_json('frameworks.json')
languages = read_json('languages.json')

target_frameworks.each do |framework|
    framework_path = File.join(private_frameworks_dir, framework['name'])

    unless Dir.exist?(framework_path)
        puts "Skip '#{framework['name']}' since directory doesn't exist on path '#{framework_path}'"
        next
    end

    languages.each do |language|
        # for debug purpose
        # next unless language.start_with? 'ru'

        language_path = File.join(framework_path, language)

        unless Dir.exist?(language_path)
            puts "Skip '#{language}' language. It is not found for framework '#{framework['name']}'"
            next
        end

        puts "Scan '#{framework['name']}' -> #{language}"

        dict = collect_localization_dictionary(language_path)

        # pick the necessary constants
        framework['values'].each do |item|
            title = item['title']
            button = item['button']

            puts "Unknown button constant '#{button}'" if button && !dict[button]

            if dict[title]
                storage.add_entry(language, dict[title], dict[button])
            else
                puts "Unknown alert constant '#{title}'"
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

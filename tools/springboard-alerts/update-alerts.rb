#!/usr/bin/env ruby
require 'awesome_print'
require 'pry'
require 'run_loop'
require_relative 'helpers'
require_relative 'localization_storage'

xcode = RunLoop::Xcode.new
private_frameworks_dir = xcode.core_simulator_dir + '/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/'

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
    return nil if found.length == 0

    raise "More than 1 occurrence of '#{framework_name}' is found" if found.length > 1

    found[0]
end

storage = LocalizationStorage.new('results/report.json')
target_frameworks = read_json('frameworks.json')
languages = read_json('languages.json')

target_frameworks.each do |framework|
    puts "Scan framework '#{framework['name']}'"
    framework_path = find_framework(xcode.core_simulator_dir, framework['name'])

    unless framework_path && Dir.exist?(framework_path)
        puts "Skip '#{framework['name']}' since directory doesn't exist on path '#{framework_path}'"
        next
    end

    puts "Found on path '#{framework_path}'"

    skipped_languages = []

    languages.each do |language|
        # for debug purpose
        # next unless language.start_with? 'ru'

        language_path = File.join(framework_path, language)

        unless Dir.exist?(language_path)
            # puts "Skip '#{language}' language. It is not found for framework '#{framework['name']}'"
            skipped_languages.push(language)
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

    if skipped_languages.length > 0
        skipped_languages_str = skipped_languages.join(',')
        puts "Skip '#{skipped_languages_str}' languages. They are not found for framework '#{framework['name']}'"
    end
end

# save updated database to the local file
storage.save

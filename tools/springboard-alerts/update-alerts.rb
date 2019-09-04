#!/usr/bin/env ruby
require 'colorize'
require 'pry'
require 'run_loop'
require_relative 'helpers'
require_relative 'localization_storage'

# Init with current Xcode
xcode = RunLoop::Xcode.new

# Try to find specific framework under CoreSimulators directory
def find_framework(root_path, framework_name)
    found = Dir.glob("#{root_path}/**/#{framework_name}")
    return nil if found.empty?

    raise "More than 1 occurrence of '#{framework_name}' is found; unexpected behavior" if found.length > 1

    found[0]
end

# Gets valid language path
# Some languages have a few aliases like 'en.lproj' and 'English.lproj', we should check all options
def find_language(framework_path, language)
    language['filenames'].find do |lang_alias|
        language_path = File.join(framework_path, lang_alias)
        return language_path if Dir.exist?(language_path)
    end

    nil
end

# Reads and parse all *.strings files in specific directory
def collect_localization_dictionary(language_dir_path)
    dict = {}
    Dir.glob("#{language_dir_path}/*.strings") do |file_path|
        pairs = read_strings(file_path)
        dict.merge!(pairs)
    end

    dict
end

# Iterate through required values for framework and try to get values from dict
# Add found values to localization storage
def pick_required_values(found_values_dict, target_framework, localization_storage, language)
    framework_name = target_framework['name']
    target_framework['values'].each do |item|
        title = item['title']
        button = item['button']
        title_value = found_values_dict[title]
        button_value = found_values_dict[button]

        puts "Unknown button constant '#{button}' for framework '#{framework_name}'".yellow if button && !button_value

        if title_value
            localization_storage.add_entry(language, title_value, button_value)
        else
            puts "Unknown alert constant '#{title}' for framework '#{framework_name}'".red
        end
    end
end

target_frameworks = read_json('frameworks.json')
languages = read_json('languages.json')
localization_storage = LocalizationStorage.new('../../Server/Resources.xcassets/springboard-alerts', languages)

target_frameworks.each do |framework|
    puts "Scan framework '#{framework['name']}'".green
    framework_path = find_framework(xcode.core_simulator_dir, framework['name'])

    unless framework_path && Dir.exist?(framework_path)
        puts "Skip '#{framework['name']}' since it was not found".red
        next
    end

    puts "Found on path '#{framework_path}'"

    available_languages = languages.select { |language| find_language(framework_path, language) }
    skipped_languages = languages - available_languages
    # puts "Available languages: #{available_languages.map { |lang| lang['name'] }}"
    puts "Skipped languages: #{skipped_languages.map { |lang| lang['name'] }}".yellow unless skipped_languages.empty?

    available_languages.each do |language|
        language_name = language['name']
        language_path = find_language(framework_path, language)

        found_values_dict = collect_localization_dictionary(language_path)
        pick_required_values(found_values_dict, framework, localization_storage, language_name)

        # debug info
        if ENV['DEBUG'] && language_name == 'en'
            report_path = "reports/#{framework['name']}.#{language_name}.json"
            save_json(report_path, found_values_dict)
        end
    end
end

# save updated database to the local file
localization_storage.save

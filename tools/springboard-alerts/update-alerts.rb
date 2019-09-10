#!/usr/bin/env ruby
require 'colorize'
require 'pry'
require 'run_loop'
require_relative 'helpers'
require_relative 'localization_storage'

# some languages have two spellings: "en" vs "English"
language_mapping = {
  'Danish' => 'da',
  'Dutch' => 'de',
  'English' => 'en',
  'French' => 'fr',
  'German' => 'de',
  'Italian' => 'it',
  'Japanese' => 'ja',
  'Portuguese' => 'pt',
  'Russian' => 'ru',
  'Spanish' => 'es',
  'Swedish' => 'se'
}

language_to_ignore = [
  'Base'
]

# Init with current Xcode
xcode = RunLoop::Xcode.new

# Try to find specific framework under CoreSimulators directory
def find_framework(root_path, framework_name)
  found = Dir.glob("#{root_path}/**/#{framework_name}")
  return nil if found.empty?

  raise "More than 1 occurrence of '#{framework_name}' is found; unexpected behavior" if found.length > 1

  found[0]
end

# Gets all languages for framework
def find_languages(framework_path)
  Dir.glob("#{framework_path}/*.lproj")
end

def get_language_name(language_dir, language_mapping)
  lang_name = File.basename(language_dir, '.lproj')
  return language_mapping[lang_name] if language_mapping.key?(lang_name)

  lang_name
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

    puts "Unknown button constant '#{button}' for framework '#{framework_name}'(#{language})".yellow if button && !button_value

    if title_value
      localization_storage.add_entry(language, title_value, button_value)
    else
      puts "Unknown alert constant '#{title}' for framework '#{framework_name}'(#{language})".red
    end
  end
end

target_frameworks = read_json('frameworks.json')
localization_storage = LocalizationStorage.new('../../Server/Resources.xcassets/springboard-alerts')

target_frameworks.each do |framework|
  puts "Scan framework '#{framework['name']}'".green
  framework_path = find_framework(xcode.core_simulator_dir, framework['name'])

  unless framework_path && Dir.exist?(framework_path)
    puts "Skip '#{framework['name']}' since it was not found".red
    next
  end

  puts "Found on path '#{framework_path}'"

  find_languages(framework_path).each do |language_path|
    language_name = get_language_name(language_path, language_mapping)
    next if language_to_ignore.include?(language_name)

    found_values_dict = collect_localization_dictionary(language_path)
    pick_required_values(found_values_dict, framework, localization_storage, language_name)

    # debug info
    if ENV['DEBUG'] && language_name == 'en'
      report_path = "reports/#{framework['name']}/#{xcode.version}.#{language_name}.json"
      save_json(report_path, found_values_dict)
    end
  end
end

# save updated database to the local file
localization_storage.save

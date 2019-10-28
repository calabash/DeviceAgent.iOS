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
  'Swedish' => 'se',
  'zh-Hans-US' => 'zh_CN',
  'zh-Hant-US' => 'zh_TW',
  'zh-Hant-HK' => 'zh-HK',
  # Norwegian, it is the same language: preferredLanguage returns 'nb' but translation folder is named as 'no'
  'nb' => 'no'
}

language_to_ignore = [
  'Base'
]

# Init with current Xcode
xcode = RunLoop::Xcode.new
root_dir = xcode.core_simulator_dir
root_dir = ARGV[0] unless ARGV.empty? || ARGV[0].empty?

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
def pick_required_values(found_values_dict, target_values, localization_storage, language)
  unknown_alert_constants = []
  unknown_button_constants = []

  target_values.each do |item|
    title = item['title']
    button = item['button']
    default_value = item['default_value']
    default_value = true if default_value.nil?

    title_value = found_values_dict[title]
    button_value = found_values_dict[button]

    if button && !button_value
      unknown_button_constants.push(button)
    end

    if title_value
      localization_storage.add_entry(language, title_value, button_value, default_value)
    else
      unknown_alert_constants.push(title)
    end
  end

  return unknown_alert_constants, unknown_button_constants
end

target_frameworks = read_json('frameworks.json')
localization_storage = LocalizationStorage.new('../../Server/Resources.xcassets/springboard-alerts')

target_frameworks.each do |framework|
  puts "Scan framework '#{framework['name']}'".green
  framework_path = find_framework(root_dir, framework['name'])

  unless framework_path && Dir.exist?(framework_path)
    puts "Skip '#{framework['name']}' since it was not found".red
    next
  end

  puts "Found on path '#{framework_path}'"

  unknown_alert_constants = {}
  unknown_button_constants = {}

  find_languages(framework_path).each do |language_path|
    language_name = get_language_name(language_path, language_mapping)
    next if language_to_ignore.include?(language_name)

    found_values_dict = collect_localization_dictionary(language_path)
    unknown_alerts, unknown_buttons = pick_required_values(found_values_dict, framework['values'], localization_storage, language_name)

    # log missed alerts and buttons for debug
    unknown_alerts.each do |unknown_alert|
      unknown_alert_constants[unknown_alert] = [] unless unknown_alert_constants.key?(unknown_alert)
      unknown_alert_constants[unknown_alert].push(language_name)
    end
    unknown_buttons.each do |unknown_button|
      unknown_button_constants[unknown_button] = [] unless unknown_button_constants.key?(unknown_button)
      unknown_button_constants[unknown_button].push(language_name)
    end

    # debug info
    if ENV['DEBUG'] && language_name == 'en'
      report_path = "reports/#{framework['name']}/#{xcode.version}.#{language_name}.json"
      save_json(report_path, found_values_dict)
    end
  end

  if unknown_alert_constants.any?
    unknown_alert_constants.each_pair do |key, value|
      puts "Unknown alert constant '#{key}' for framework '#{framework['name']}' (#{value.join(',')})".red
    end
  end

  if unknown_button_constants.any?
    unknown_button_constants.each_pair do |key, value|
      puts "Unknown button constant '#{key}' for framework '#{framework['name']}' (#{value.join(',')})".red
    end
  end

end

# save updated database to the local file
localization_storage.save
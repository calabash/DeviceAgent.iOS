#!/usr/bin/env ruby
require 'json'
require 'pry'
require 'run_loop'
require_relative 'helpers'

# Init with current Xcode
xcode = RunLoop::Xcode.new

output_path = File.expand_path("reports/all-alerts/#{xcode.version}/")

def add_entries_to_collection(lang, file_path, dict, collection)
  collection[lang] ||= {}
  collection[lang][file_path] = dict
end

def collect_localization_dictionary(lang_dir_path)
  dict = {}
  Dir.glob("#{lang_dir_path}/*.strings") do |file_path|
    pairs = read_strings(file_path)
    dict.merge!(pairs)
  end
  dict
end

collection = {}
Dir.glob("#{xcode.core_simulator_dir}/**/*.lproj") do |lang_dir|
  puts "Scanning #{lang_dir}..."
  lang_name = File.basename(lang_dir, '.lproj')
  dict = collect_localization_dictionary(lang_dir)
  add_entries_to_collection(lang_name, lang_dir, dict, collection)
end

puts "Saving to #{output_path}"
collection.keys.each do |lang|
  output_file_path = File.join(output_path, "#{lang}.json")
  save_json(output_file_path, collection[lang])
end

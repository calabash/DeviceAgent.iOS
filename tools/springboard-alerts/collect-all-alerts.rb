#!/usr/bin/env ruby
require 'json'
require 'pry'
require_relative 'helpers'

root_dir = "/Library/Developer/CoreSimulator/Volumes/iOS_21F79/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 17.5.simruntime"
root_dir = ARGV[0] unless ARGV.empty? || ARGV[0].empty?

output_path = File.expand_path("reports/all-alerts/#{17.5}/")

def add_entries_to_collection(lang, file_path, dict, collection)
  collection[lang] ||= {}
  collection[lang][file_path] = dict
end

def collect_localization_dictionary(lang_dir_path)
  dict = {}
  
  3.times do
    sleep(0.005)
    begin
      Dir.glob("#{lang_dir_path}/*.strings") do |file_path|
        pairs = read_strings(file_path)
        dict.merge!(pairs)
      end
      break
    rescue StandardError => e
      puts e.message
      puts e.backtrace.inspect
      next
    end
  end

  dict
end

collection = {}
Dir.glob("#{root_dir}/**/en.lproj") do |lang_dir|
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

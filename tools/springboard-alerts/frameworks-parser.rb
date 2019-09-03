class FrameworksParser
    def initialize(langs)
        @langs = langs
    end

    def parse_constants(dir_path)
        xcode_version = `#{"xcodebuild -version"}`.split(' ')[1]
        puts "parse constants for xcode #{xcode_version}"
        for lang in @langs
            puts "Language: #{lang}"
            out_array = []
            Dir.glob("#{dir_path}/**/#{lang}.lproj/*.strings") do |file_path|
                p file_path
                framework = read_strings(file_path)
                framework['path'] = file_path
                out_array.push(framework)
            end
            report_path = "constants/xcode_#{xcode_version}_constants.#{lang}.json"
            save_to_json_file(report_path, out_array)
        end
    end
end
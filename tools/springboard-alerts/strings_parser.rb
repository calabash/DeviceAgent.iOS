class PlistParser
    def self.parse(file_path)
        content_array = read(file_path)
        if content_array[0].strip != 'Dict {' || content_array[-1].strip != '}'
            raise "Invalid strings file '#{file_path}'"
        end

        parse_key_value_pairs(content_array[1..-2])
    end

    def self.parse_key_value_pairs(content_array)
        pairs = {}
        content_array.each do |line|
            parts = line.split('=')
            key = parts[0].strip
            value = parts[1].strip
            if key && value
                pairs[key] = value
            end
        end

        pairs
    end

    def self.read(file_path)
        args = ['/usr/libexec/PlistBuddy', '-c', 'Print', "\"#{file_path}\""].join(' ')
        content = `#{args}`
        content.each_line.inject([]) do |content_array, line|
            line.gsub!("\n", "")
            content_array.push(line)
        end
    end

    private_class_method :read
    private_class_method :parse_key_value_pairs
end

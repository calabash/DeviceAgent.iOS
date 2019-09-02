def read_json(file_path)
    unless File.exist?(file_path)
        raise "The file '#{file_path}' is not found"
    end

    input_file = File.read(file_path)
    input_data = JSON.parse(input_file)
    input_data
end

def read_strings(file_path)
    unless File.exist?(file_path)
        raise "The file '#{file_path}' is not found"
    end

    args = ['plutil', '-convert', 'json', '-o', '"-"', "\"#{file_path}\""].join(' ')
    content = `#{args}`
    content_dict = JSON.parse(content)
end
    

def save_to_json_file(file_path, content)
    # create directory if doesn't exist
    dirname = File.dirname(file_path)
    Dir.mkdir(dirname) unless Dir.exist?(dirname)

    File.open(file_path, mode: 'w') do |file|
        file.write(JSON.pretty_generate(content))
    end
end

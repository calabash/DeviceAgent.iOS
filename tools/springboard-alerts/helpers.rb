# Reads and parse JSON object from local file
def read_json(file_path)
    raise "The file '#{file_path}' is not found" unless File.exist?(file_path)

    input_file = File.read(file_path)
    input_data = JSON.parse(input_file)
    input_data
end

# Reads and parse *.strings file and returns the list of key-value pairs
def read_strings(file_path)
    raise "The file '#{file_path}' is not found" unless File.exist?(file_path)

    args = ['plutil', '-convert', 'json', '-o', '"-"', "\"#{file_path}\""].join(' ')
    content = `#{args}`
    JSON.parse(content)
end

# Put JSON object to the local file
def save_json(file_path, content)
    # create directory if doesn't exist
    dirname = File.dirname(file_path)
    Dir.mkdir(dirname) unless Dir.exist?(dirname)

    File.open(file_path, mode: 'w') do |file|
        file.write(JSON.pretty_generate(content))
    end
end

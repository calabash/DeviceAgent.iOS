# Reads and parses JSON object from local file
def read_json(file_path)
    raise "The file '#{file_path}' is not found" unless File.exist?(file_path)

    input_file = File.read(file_path)
    JSON.parse(input_file)
end

# Reads and parses *.strings file
# returns the list of key-value pairs
def read_strings(file_path)
    raise "The file '#{file_path}' is not found" unless File.exist?(file_path)

    args = ['plutil', '-convert', 'json', '-o', '"-"', "\"#{file_path}\""].join(' ')
    content = `#{args}`
    JSON.parse(content)
end

# Puts JSON object to the local file
def save_json(file_path, content)
    # create directory if doesn't exist
    dirname = File.dirname(file_path)
    Dir.mkdir(dirname) unless Dir.exist?(dirname)

    File.open(file_path, mode: 'w') do |file|
        file.write(JSON.pretty_generate(content))
    end
end

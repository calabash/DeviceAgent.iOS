require_relative 'helpers'

# Storage class that helps to extend existing localization database with new values
# Use json format to store database
class LocalizationStorage
    def initialize(file_path)
        @storage = {}
        @file_path = file_path

        # first run of tool
        return unless File.exist?(file_path)

        @storage = read_json(file_path)
    end

    # Adds new alert with specific language and title to the database
    def add_entry(language, title, button)
        if (entry = find_entry(language, title))
            if entry['button'] != button
                # Usually, it means that there are a few alerts with the identical title but different button text
                # Just report about such issues for now. Probably, we want to handle it in future
                raise 'Localization storage already contains alert with the identical title but other button text.'
            end

            return
        end

        @storage[language] ||= []
        @storage[language].push({
            'title' => title,
            'button' => button,
            'shouldAccept' => true
        })
    end

    # Finds alert with specific language and title in the database
    def find_entry(language, title)
        return nil unless @storage[language]

        @storage[language].find { |item| item['title'] == title }
    end

    # Saves database to the file
    def save
        save_to_json_file(@file_path, @storage)
    end
end

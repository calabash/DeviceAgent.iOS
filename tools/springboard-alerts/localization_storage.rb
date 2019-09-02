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
        @storage[language] ||= []

        alert_entry = add_alert(language, title)
        add_button_to_alert(alert_entry, button) if button
    end

    # Adds new alert if it doesn't exist yet
    def add_alert(language, title)
        alert_entry = @storage[language].find { |item| item['title'] == title }
        return alert_entry if alert_entry

        alert_entry = {
            'title' => title,
            'buttons' => [],
            'shouldAccept' => true
        }
        @storage[language].push(alert_entry)
        alert_entry
    end

    # Adds button to the existing alert if it doesn't contain it
    def add_button_to_alert(alert_entry, button)
        button_entry = alert_entry['buttons'].find { |v| v == button }
        alert_entry['buttons'].push(button) if button_entry.nil?
    end

    # Saves database to the file
    def save
        save_json(@file_path, @storage)
    end
end

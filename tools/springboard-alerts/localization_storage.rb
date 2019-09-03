require_relative 'helpers'

# Storage class that helps to extend existing localization database with new values
# Use json format to store database
class LocalizationStorage
    def initialize(storage_path, languages)
        @storage_path = storage_path
        @languages = languages.map { |lang| lang['name'] }
        load
    end

    # Adds new alert with specific language and title to the database
    def add_entry(language, title, button)
        @storage[language] ||= []

        alert_entry = add_alert(language, title)
        add_button_to_alert(alert_entry, button) if button
    end

    # Saves database to the local disk
    def save
        @languages.each do |lang|
            language_path = File.join(@storage_path, lang + '.json')
            save_json(language_path, @storage[lang])
        end
    end

    private

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

    # Loads database from the local disk
    def load
        @storage = {}
        @languages.each do |lang|
            language_path = File.join(@storage_path, lang + '.json')
            @storage[lang] ||= []
            @storage[lang] = read_json(language_path) if File.exist?(language_path)
        end
    end
end

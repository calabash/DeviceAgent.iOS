require_relative 'helpers'

# Storage class that helps to extend existing localization database with new values
# Use json format to store database
class LocalizationStorage
  def initialize(storage_path)
    @storage_path = File.expand_path(storage_path)
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
    @storage.keys.each do |lang|
      language_path = get_local_language_path(lang)
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

  # Returns local disk path for specific language
  def get_local_language_path(language)
    # DeviceAgent.iOS/Server/Resources.xcassets/springboard-alerts/springboard-alerts-en.dataset/alerts.json
    File.join(@storage_path, "springboard-alerts-#{language}.dataset/alerts.json")
  end

  def get_language_from_language_path(language_path)
    # DeviceAgent.iOS/Server/Resources.xcassets/springboard-alerts/springboard-alerts-en.dataset/alerts.json
    temp_path = File.dirname(language_path) # cut 'alerts.json'
    temp_path = File.basename(temp_path, '.dataset') # cut 'dataset' and parent folders
    raise 'Invalid file path' unless temp_path.start_with?('springboard-alerts-')

    # cut 'springboard-alerts-'
    temp_path[19..-1]
  end

  # Loads database from the local disk
  def load
    @storage = {}
    Dir.glob("#{@storage_path}/springboard-alerts-*.dataset/alerts.json").each do |language_path|
      lang = get_language_from_language_path(language_path)
      @storage[lang] ||= []
      @storage[lang] = read_json(language_path) if File.exist?(language_path)
    end
  end
end

# Springboard-alert tool
The main goal of this tool is retrieving system springboard alerts from the Xcode.app and saving it locally to JSON format.
The database of alerts is extended with every new Xcode release. This database is used by DeviceAgent.iOS to automatically dismiss springboard alerts during test running.

### Requirements

* Xcode >= 9.4.1
* ruby >= 2.3

### How to use
```
$ cd DeviceAgent.iOS
$ make update-alerts
```

Changes will be done under `Server/Resources.xcassets/springboard-alerts/**`

### Configuration
File `languages.json` is used to configure the list of languages for retrieving.
- `name` is known alias of language
- `filenames` is array of possible language folder names for looking (for example, English can be `en.lproj` or `English.lproj`)

File `frameworks.json` is used to configure the list of frameworks that will be parsed and the list of constants for retrieving
- `name` is framework name
- `values` is the list of constats for retrieving
    - `title` is contant of alert message
    - `button` is constant of button that should be clicked to dismiss alert

### Utility script "collect-all-alerts.rb"
There is a utility tool `collect-all-alerts.rb` that reads all `*.strings` files under `CoreSimulator` dir for current Xcode and create alert dictionary.  
It is useful to find the source framework for some alert.  
**Note:** Scanning can take much time (~30 minutes)

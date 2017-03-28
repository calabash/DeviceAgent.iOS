### 1.1.0

* Dismiss 'Open in' alerts automatically #212
* Fix PT-br APNS SpringBoard alert localizations #211
* Add Korean localizations for SpringBoard alerts #209
* Adds handling for VPN configuration springboard alert. #208
* Update for Xcode 8.3 #206
* Allow users to interact with SpringBoard alerts and control whether or
  not alerts are automatically dismissed #205
* Server: disable screenshots on server start #204

### 1.0.6

1.0.5 was never released.

* Add mach clock and a simple waiter #202
* SpringBoard#queryForAlert: skip\_waitForQuiescence check #201
* Increase touch duration to 0.2 to match XCUITest #198
* Use CocoaLumberjack for logging #197
* Update CocoaLumberjack to 3.0.0 #196
* TestApp: update to calabash.framework 0.20.4 #194
* Improve hitpoint and visibility calculation #193
* Fix text entry for i386/armv7 devices #192
* Dismiss SpringBoard alerts by touching alert buttons with coordinates #191
* SpringBoard: ask UIApplication for SpringBoard alert before making an
  expensive XCUITest query #190
* POST /session raises when app is not installed and when app fails to
  launch #189

### 1.0.4

DeviceAgent can dismiss SpringBoard alerts in any orientation.

* Replace NSRunLoop runUntilDate: with CFRunLoopRunInMode to avoid
  unreliable NSDate behaviors #187
* SpringBoard: use XCUIElement#tap to dismiss alerts #186
* DeviceAgent: generate and distribute a dSYM #185

### 1.0.3

DeviceAgent now dismisses the following US English SpringBoard alerts:

* Sign In to iTunes
* Access Apple Music And Your Media
* Health Access
* Enable Dictation

@oscartanner added support for Brazil PT for most of the SpringBoard
alerts.

* Add iTunes and Apple Music SpringBoard alerts #183
* Add UITextView to TestApp #181
* Use Testmanagerd `XCT_sendString` to enter text except on i386/armv7
  devices #178
* Fixes if statement in querying delete key for clear text #177
* Add GET environment and arguments #176
* Update SpringBoard alert definitions for iOS 10 #175
* clear\_text should tap keyboard delete key #170

### 1.0.2

* Cucumber: add @tree and @wildcard query Scenarios #169
* rm completion from threadutils runSync #168
* Drag avoid inertia #167
* Fix drag repetitions and correct duration from first point #164
* Touch: increase touch duration by 0.01 #161
* update default session ID #159

### 1.0.1

* Server: branch on element and snapshot when computing visibility #163
* Remove exception handling when computing visibility attributes in
  JSONUtils #162
* Server: resolve application before entering text #160

### 1.0.0

First release

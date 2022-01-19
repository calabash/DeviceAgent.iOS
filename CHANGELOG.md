### 2.4.2

* Added support of Xcode 13.2.1.

### 2.4.1

* Added support of Xcode 13.1.
* Added handling of "Apple ID Required" notification.
* Updated calabash.xcframework.

### 2.4.0

* Added support of Xcode 13.0 and iOS 15.

### 2.3.0

* Added depndencies as xcframework format.
* Added supporting of Apple Silicon arm64 platform for simulator.
* Added missed alerts localiztions from Xcode 12.5.
* Fixed issue with tapping on elements in horizontal screen orientation.

### 2.2.7

* Added fixes for Xcode 12.5 build
* Updated Private Headers from Xcode 12.5

### 2.2.6

* Added fixes for Xcode 12.4 build

### 2.2.5

* Added alerts from iOS 14
* Updated Private Headers from Xcode 12.2

### 2.2.4

* Added support of Xcode 12.0

### 2.2.3

* Fixed pubishing of new DeviceAgent.iOS version

### 2.2.2

* Adapt architecture and identitiy to be able to build on Xcode 12 #393

### 2.2.1

The 2.2.0 release was cancelled.

We discovered a problem with running tests against a DeviceAgent built with
Xcode 11.4.  Xamarin.UITest, run-loop, and Test Cloud will use a DeviceAgent
built with Xcode 11.3.1 until we sort out the problem.  Tracking here (private
link):

DeviceAgent built with Xcode 11.4 crashes after launching the AUT [ADO](https://msmobilecenter.visualstudio.com/Mobile-Center/_workitems/edit/79012)

* Add support for Xcode 11.4 beta 3 #377 Thanks @sergey-plevako-badoo
* Add alerts new in Xcode 11.4 #382 Thanks @humbled

### 2.1.0

* Fixes various problems in dismiss-SpringBoard-alert system.

### 2.0.2

* Add push notification alerts from iOS 12, 13 #358

### 2.0.1

* POST/session: on error, retry launching AUT #355
* build/publish: can upload to Azure Blob Storage locally #354

### 2.0.0

* Add support for new Apple hardware: iPhone 11, 11 Pro and 11 Pro Max, iPad
  mini 5th Gen and iPad Air 2019 #350
* Update private headers for Xcode 11 GM #348
* Publish DeviceAgent.iOS artifacts to blob storage #330
* Control ADO pipeline triggers in yaml #331
* Add support for Xcode 10.3 #332
* Use KeyVault for secrets in ADO pipeline #333
* Update private headers for Xcode 11 beta 6 #334
* Xcode 11 beta 6: deal with visibility, keyboard, and 3 finger taps #335
* SpringBoard alerts: read alert titles from .strings files #336
* SpringBoard alerts: implement tools to parse output of strings files and store
  as json #338
* Spring Board alerts: dismiss algorithm can handle cases were alert buttons
  have alternative titles #339
* Spring Board alerts: use regex to match alert titles (improve on existing
  'contains' logic) #342
* Improve SpringBoard alert extraction tools #343
* Import only current language for springboard-alerts #344
* Add one-off fixes for existing SpringBoard alert bugs #345

### 1.4.0

* Add Xcode 11 support #317 #318 #319 #320 #321 #322
* Cleanup #324

### 1.3.4

No changes the DeviceAgent.iOS project.

Removed appium-junit directory from the project to satisfy a security
requirement in Xamarin.UITest (which has DeviceAgent as a dependency).

### 1.3.3

* Add new Spring 2019 iPad models #312
* Update private headers for Xcode 10.2 #311
* SafariWebController test fails for iPhone XR and XS Max. #308
* Update private headers for Xcode 10.2 #306

### 1.3.2

* Added new Korean alert for location from iOS 12 #303
* Improve performance of element JSON serialization and simplify
  visibility heuristic #300

### 1.3.1

* Add new iPhone 10S, 10S Max, and 10R model numbers #296

### 1.3.0

* Server: add speech recognition alert texts #293
* Server: add new localizations for SB alerts #294

### 1.2.6

Provide support for Xcode 10 beta 6.

* Improve query speed by loading BootstrapInject.dylib into AUT #282
* remove simulator log redirect #285 @AlexWellsHS
* SpringBoard: update Italian localizations #287
* Support for Xcode 10 beta 6 #291

### 1.2.5

Provides support for Xcode 9.4.

* Server: add French localization for 3-button location alert #280
* Server: add Apple Music en and ru alerts #277

### 1.2.4

Provides support for Xcode 9.3 and prepares for OSS release.

* Xcode: Gemüse Bouche dylib libraries and testable UI in TestApp #265
* Scripts to submit XCUITest target for TestApp to Test Cloud #266
* Appium JUnit: can submit an example to App Center/Test Cloud #267
* Xcode 9.3 beta 2 support #268
* Xcode 9.3 beta 3 support #269
* Server: remove EnterTextIn and ClearTextIn; unused gestures #270
* added Russian SpringBoard alerts localizations (DeviceAgent) #271
* Xcode 9.3 beta 4 support #272
* Add test for XCUIElementType's #273
* Fix visibility for elements on macOS sierra running Xcode < 9.3 #274
* OSS: changes for MSFT open source review #275

### 1.2.3

* Xcode: target + script for running XCUITests against arbitrary .app #260
* Server: drag-n-drop can start with a touch-and-hold #259
* TestApp: update URLs to calabash-ci.xyz domain #258

### 1.2.2

* Use XCUIApplication#terminate to terminate applications #256
* Server: XCUIElement with type Any may or may not respond to WebDriver
  methods #255
* Add iOS 11 'would like to add to your photos' SpringBoard alert #254
* SB: add camera alert for iOS 11 de #252
* Server: update CBXDevice with iPhone 8 and 10 models #251

### 1.2.1

* Server: handle 3 button SpringBoard location alert #249

### 1.2.0

Support for Xcode 9/iOS 11 testing against physical devices and
simulators.

* Xcode 9: redirect simulator logs to ~/Library/CoreSimulator/<UDID>/system.log #247
* Server: XCUIApplication cannot be first responder #246

### 1.1.3

Premilinary support for Xcode 9/iOS 11 testing against physical devices.

Most gestures are failing on iOS Simulators.

* Server: decrease default touch time to 0.1 #244
* Update device rotation gesture and orientation reporting for iOS 11 #243
* Server: revert pull request #237 - remove pre-launch is-installed
  check; does not work on iOS 11 #242
* Xcode 9: text queries not forwarding to WebDriver attributes #241
* Server: handle infinite and CGFloat max/min floating point values #240
* Server: OR predicates not evaling correctly on web views - updated
  tests; issue is not resolved #239
* SB: add Hebrew and Italian SpringBoard alerts #238
* Use XCUIApplication to check if application is installed before launch #237
* Update CBXDevice for iPad Pro 10.5 and arm64 devices #236
* Update build scripts to publish TestApp to test-cloud-test-apps #235

### 1.1.2

* Server: add pt-BR alert definition for APNS #233
* Perform app query before resolving the application when checking
  visibility #232
* Server: GET /version returns DeviceAgent build info #227
* Server: add selected key to element JSON #223
* Server: add focus information to element JSON #222
* POST /session can terminate AUT if it is running #220
* SpringBoard: add French 'no SIM card installed' localization #216

### 1.1.1

DeviceAgent 1.1.0 was never released because of iOSDeviceManager
failures related to Xcode 8.3.

* DeviceAgent.xctest bundle includes xctestrun files #214
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

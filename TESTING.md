## End to End Cucumber Tests

### Requirements

* Xcode >= 8.3
* ruby >= 2.3.1
* bundler gem
* xcpretty gem

Preferred directory layout:

```
$ tree -L 2 -d
.
├── calabash
│   ├── DeviceAgent.iOS
│   ├── iOSDeviceManager
│   ├── run_loop
```

### TODO

1. pull git@github.com:calabash/calabash-codesign.git
2. pull git@github.com:calabash/iOSDeviceManager.git and checkout develop
3. pull git@github.com:calabash/DeviceAgent.iOS.git and checkout develop
4. pull git@github.com:calabash/run_loop.git and checkout develop
5. Configure bundler to use local run_loop: `$ bundle config local.run_loop /path/to/run_loop`

### Create TestCloudDev.keychain

This is required to build the Xcode project which have hard-wired code signing requirements.

```
$ <calabash-codesign-repo>/apple/create-keychain.sh
```

Output like this is normal:

```
security: SecPolicySetValue: One or more parameters passed to a function were not valid.
```

### Build DeviceAgent products

```
$ cd DeviceAgent.iOS
$ make test-app
$ make test-ipa
$ make ipa-agent
$ make app-agent
```

### Build iOSDeviceManager and install TestApp

```
$ make build
$ cd Products
$ ./iOSDeviceManager install <UDID> \
  ../../DeviceAgent.iOS/Products/ipa/TestApp/TestApp.app
```

### Build DeviceAgent Stack to run_loop

```
# Task responds to DEVICE_AGENT and IOS_DEVICE_MANAGER for non-standard paths.
# See Preferred layout in requirements section.
$ cd run_loop
$ rake device_agent:install

# Show what files were touched
$ git status

# Revert DeviceAgent binaries
$ rake device_agent:checkout
```

### DeviceAgent cucumber tests

This is a smoke test to see if everything is configured correctly.

```
# Requires you have made the TestApp for simulator (above)
$ cd DeviceAgent.iOS/cucumber
$ bundle update
$ be cucumber -t @args
```

To target a physical device:

```
***** Install TestApp FIRST!!! (as above) *****

$ DEVICE_TARGET=< udid > be cucumber -t @args -t ~@simulator
$ DEVICE_TARGET=< device name > be cucumber -t @args -t ~@simulator
```

All the cucumber tests are expected to pass.

Please note that some tests are not available for physical devices (`-t ~@simulator`).

To see more information, use `DEBUG=1 be cucumber`.

If you make a change in run_loop, it will be reflected in the next `cucumber` run.

Edit `cucumber/features/support/01_launch.rb`:

```
# Switch from `iOSDeviceManager` launcher to `xcodebuild` launcher.
# Maintainers only
# :cbx_launcher => :xcodebuild,
```

When running with `xcodebuild` you will need to manually update the
DeviceAgent.iOS Xcode code signing settings for the AppStub target
 _if_ your device is not in `calabash-codesign` provisioning profiles.

### Log Files

```
# Available after run-loop is installed.
$ run-loop simctl tail

# Available after first iOSDeviceManager command is run.
$ tail -F ~/.calabash/iOSDeviceManager/logs/current.log

# Available after first `xcodebuild` cucumber run.
$ tail -F ~/.run-loop/xcuitest/xcodebuild.log
```

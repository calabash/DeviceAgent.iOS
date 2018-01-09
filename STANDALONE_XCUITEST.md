## Stand Alone XCUITest

```shell
$ bin/standalone-xcuitest/test-app.sh

Run arbitrary XCUITests against any .app

Usage:

bin/standalone-xcuitest/test-app.sh path/to/AUT.app [simulator or device UDID]

* .ipa archives must be expanded.
* If no UDID is provided, a default will be used.
* Tests targeting a physical device require the .app
  is signed for the device.  The app will be installed
  on the device as part of the xcodebuild command.
```

This script can be used to run arbitrary XCUITests against any .app.

1. Obtain a .app from the client.  If you are given a .ipa, expand it
   to reveal the Payload/Example.app.
2. If you are targetting a physical device, resign the Example.app for
   the target device.  You do not need to install the Example.app on the
   device.
3. Add tests to StandAloneUITests/StandAloneUITests.m.
4. Run the script as indicated above (see Usage).

Don't commit changes StandAloneUITests.m.

### Troubleshooting

This technique uses an .xctestrun file.

See `man xcodebuild.xctestrun` for more options.

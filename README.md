| master  | develop | [versioning](VERSIONING.md) | [license](LICENSE) | [contributing](CONTRIBUTING.md)|
|---------|---------|-----------------------------|--------------------|--------------------------------|
|[![Build Status](https://travis-ci.com/calabash/DeviceAgent.iOS.svg?token=fsyxqhAht7X7tLURqAAp&branch=master)](https://travis-ci.com/calabash/DeviceAgent.iOS) | [![Build Status](https://travis-ci.com/calabash/DeviceAgent.iOS.svg?token=fsyxqhAht7X7tLURqAAp&branch=develop)](https://travis-ci.com/calabash/DeviceAgent.iOS)| [![Version](https://img.shields.io/badge/version-1.2.1-green.svg)](https://img.shields.io/badge/version-1.2.1-green.svg) |[![License](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)](LICENSE) | [![Contributing](https://img.shields.io/badge/contrib-gitflow-orange.svg)](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow/)|

## DeviceAgent.iOS

### Docs

```
$ make docs
$ open documentation/html/hierarchy.html
```

Generates appledocs for any header file under the `Server` directory. If any
headers contain no documentation, a warning will be generated. Which will
cause CI to fail.  You have been warned.

### Building

Maintainers must install the calabash/calabash-codesign private repo.
Details are below.

All build products are staged to the ./Products directory - even when
building from Xcode.

Enjoy.

#### Xcode

To build the DeviceAgent-Runner.app from Xcode, select the DeviceAgent
scheme and Build for Testing (Shift + Command + U).  Rinse and repeat
for simulator or device targets.  This will generate binaries for
distribution in the ./Products directory.  The post-build staging is done
in the DeviceAgent scheme's Build Post Action Script.

The logs for this script can be found here:

```
/tmp/CBX-Runner-post-build.log
```

Inspect that log file for code signing, patching, and staging errors.

The application targets can be built as usual (Command + B).

You should never have to build the UnitTest target for distribution.

#### Command line

Requires Xcode 8.3.3 and iOS 9 or higher.

Requires ruby >= 2.0.  The latest ruby release is preferred.

```
$ git clone git@github.com:calabash/DeviceAgent.iOS.git ios-device-agent
$ cd ios-device-agent
$ bundle install

# Make the agent ipa and app
$ make ipa-agent
$ make app-agent

# Unit tests; running against simulators
$ make unit-tests

# Cucumber integration tests
$ make test-app
$ cd cucumber
$ bundle update
$ be cucumber
```

To build with an alternative Xcode:

```
$ DEVELOPER_DIR=/Xcode/7.3/Xcode-beta.app make < rule >
```

If you have build errors, see the xcpretty section below.

### Code Signing

If you are a maintainer, you _must_ install the codesign tool.

* https://github.com/calabash/calabash-codesign

If see messages like this:

```
iPhone Developer: ambiguous matches
```

then you must either:

1. `$ CODE_SIGN_IDENTITY="< cert name >" make ipa-cal` (preferred)
2. Update the Xcode project with a specific Code Signing entity.  **DO
   NOT CHECK THESE CHANGES INTO GIT.**

Maintainers should be using the Calabash.keychain (calabash/calabash-codesign).

### Contributing

* The Calabash iOS Toolchain uses git-flow.
* Contributors should not bump the version.
* See the [CONTRIBUTING.md](CONTRIBUTING.md) guide.
* There is a style guide: [STYLE\_GUIDE.md](STYLE\_GUIDE.md).
* Pull-requests with unit tests will be merged faster.
* Pull-requests with Cucumber integration tests will be merged even faster.

### Releasing

See the [CONTRIBUTING.md](CONTRIBUTING.md) document for instructions.

### xcpretty

https://github.com/supermarin/xcpretty

We use xcpretty to make builds faster and to reduce the amount of
logging.  Travis CI, for example, has a limit on the number of lines of
logging that can be generated; xcodebuild breaks this limit.

The only problem with xcpretty is that it does not report build errors
very well.  If you encounter an issue with any of the make rules, run
without xcpretty:

```
$ XCPRETTY=0 make ipa-agent
```

### Licenses

DeviceAgent uses several third-party sources.  You can find the licenses for
these sources in the Licenses directory.


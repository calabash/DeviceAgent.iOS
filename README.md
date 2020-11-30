| develop | master | [versioning](VERSIONING.md) | [license](LICENSE) | [contributing](CONTRIBUTING.md)|
|---------|--------|-----------------------------|--------------------|--------------------------------|
|[![Build Status](https://msmobilecenter.visualstudio.com/Mobile-Center/_apis/build/status/test-cloud/xamarin-uitest/calabash.DeviceAgent.iOS?branchName=develop)](https://msmobilecenter.visualstudio.com/Mobile-Center/_build/latest?definitionId=3510&branchName=develop) | [![Build Status](https://msmobilecenter.visualstudio.com/Mobile-Center/_apis/build/status/test-cloud/xamarin-uitest/calabash.DeviceAgent.iOS?branchName=master)](https://msmobilecenter.visualstudio.com/Mobile-Center/_build/latest?definitionId=3510&branchName=master) | [![Version](https://img.shields.io/badge/version-2.2.4-green.svg)](https://img.shields.io/badge/version-2.2.4-green.svg) |[![License](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)](LICENSE) | [![Contributing](https://img.shields.io/badge/contrib-gitflow-orange.svg)](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow/)|

## DeviceAgent.iOS

### Requirements

* Xcode >= 10.3.1
* macOS Mojave or higher
* ruby >= 2.3

### Code Signing

Project maintainers must clone the [codesign](https://github.com/xamarinhq/calabash-codesign)
repo and install the certs and profiles. Talk to a maintainer for details.

Contributors need to touch the Xcode project file with valid credentials.

### Building

All build products are staged to the ./Products directory - even when
building from Xcode.

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

```
$ cd DeviceAgent.iOS
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
$ DEVELOPER_DIR=/Xcode/10.1/Xcode-beta.app/Contents/Developer make < rule >
```

If you have build errors, see the xcpretty section below.

### Code Signing

```
iPhone Developer: ambiguous matches
```

Ambiguous matches usually mean that the certs are contained in both your
login.keychain and the Calabash.keychain.  Delete the certs in your
login.keychain.

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


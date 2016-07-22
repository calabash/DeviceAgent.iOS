| master  | develop | [versioning](VERSIONING.md) | [license](LICENSE) | [contributing](CONTRIBUTING.md)|
|---------|---------|-----------------------------|--------------------|--------------------------------|
|[![Build Status](https://travis-ci.com/calabash/DeviceAgent.iOS.svg?token=fsyxqhAht7X7tLURqAAp&branch=master)](https://travis-ci.com/calabash/DeviceAgent.iOS) | [![Build Status](https://travis-ci.com/calabash/DeviceAgent.iOS.svg?token=fsyxqhAht7X7tLURqAAp&branch=develop)](https://travis-ci.com/calabash/DeviceAgent.iOS)| [![Version](https://img.shields.io/badge/version-0.0.0-green.svg)](https://img.shields.io/badge/version-0.0.0-green.svg) |[![License](https://img.shields.io/badge/licence-Eclipse-blue.svg)](http://opensource.org/licenses/EPL-1.0) | [![Contributing](https://img.shields.io/badge/contrib-gitflow-orange.svg)](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow/)|

## iOS DeviceAgent

### Docs

DeviceAgent is fully documented! But the docs are not published publicly.

To generate the docset,

```
$ make docs
```

Currently, this will generate appledocs for any header file under the
`Server` directory. If any headers contain no documentation, a warning
will be generated. However, *no warning will be generated for undocumented
symbols*, so please be diligent when adding new methods/properties!

Docs will be output in html in a new `documentation` directory at the
root of the project. You can open the `html/index.html` file in any
browser and have a go.

It will also install the docs into your Xcode, so you can option-click
any symbol from the repo and see the docs.

### Building

Maintainers must install the calabash/calabash-codesign private repo.
Details are below.

All build products are staged to the ./Products directory - even when
building from Xcode.

Enjoy.

#### Xcode

To build the CBXRunner from Xcode, select the XCUITestDriver scheme and
Build for Testing (Shift + Command + U).  Rinse and repeat for simulator
or device targets.  This will generate binaries for distribution in the
./Products directory.  The post-build staging is done in a Post Build Runi
Script Action in the CBXAppStub and XCUITestDriver schemes.

The logs for these scripts can be found here:

```
/tmp/CBX-Runner-post-build.log
/tmp/CBXAppStub-post-build.log
```

The application targets can be built as usual (Command + B).

You should never have to build the UnitTest target for distribution.

#### Command line

Requires Xcode 7 and iOS 9 or higher.

Requires ruby >= 2.0.  The latest ruby release is preferred.

```
$ git clone git@github.com:calabash/DeviceAgent.iOS.git ios-device-agent
$ cd ios-device-agent
$ bundle install

# Make the agent ipa and app
$ make ipa-agent
$ make app-agent

# Unit tests; running against simulators
$ make unit

# Cucumber integration tests
$ make app-unit
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

DeviceAgent uses several third-party sources.  You can find the licenses for these
sources in the third-party-licenses directory.


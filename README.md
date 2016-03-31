| master  | develop | [versioning](VERSIONING.md) | [license](LICENSE) | [contributing](CONTRIBUTING.md)|
|---------|---------|-----------------------------|--------------------|--------------------------------|
|[![Build Status](https://travis-ci.org/calabash/calabash-xcuitest-server.svg?branch=master)](https://travis-ci.org/calabash/calabash-xcuitest-server)| [![Build Status](https://travis-ci.org/calabash/calabash-xcuitest-server.svg?branch=develop)](https://travis-ci.org/calabash/calabash-xcuitest-server)| [![Version](https://img.shields.io/badge/version-1.0.0-green.svg)](https://img.shields.io/badge/version-1.0.0-green.svg) |[![License](https://img.shields.io/badge/licence-Eclipse-blue.svg)](http://opensource.org/licenses/EPL-1.0) | [![Contributing](https://img.shields.io/badge/contrib-gitflow-orange.svg)](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow/)|

## The Calabus Driver


### Building

Requires Xcode 7 and iOS 9 or higher.

Requires ruby >= 2.0.  The latest ruby release is preferred.

```
$ git clone git@github.com:calabash/calabash-xcuitest-server.git
$ cd calabash-xcuitest-server
$ bundle update
$ make app
$ make ipa
$ make runner
```

To build with an alternative Xcode:

```
$ DEVELOPER_DIR=/Xcode/7.2b2/Xcode-beta.app make < rule >
```

If you have build errors, see the xcpretty section below.

Maintainers must install the calabash/calabash-resign private repo. Details are below.

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

### Testing

To run the Objective-C unit tests:

```
$ bundle update
$ make unit
```

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
$ XCPRETTY=0 make ipa
```

### Licenses

Calabash iOS Server uses several third-party sources.  You can find the
licenses for these sources in the third-party-licenses directory.


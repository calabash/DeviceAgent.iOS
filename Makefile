all:
	$(MAKE) clean
	$(MAKE) app-agent
	$(MAKE) ipa-agent

clean:
	rm -rf build
	rm -rf Products

# Builds the CBX-Runner.ipa and CBXAppStub.ipa and stages them
# to ./Products/ipa.
#
# Xcode Product > Build For > Testing stages ipas to the same directory.
#
# Respects the CODE_SIGN_IDENTITY variable, which might be necessary
# if you have multiple Developer accounts.
# $ CODE_SIGN_IDENTITY="iPhone Developer: Joshua Moody (8<snip>F)" make ipa
ipa-agent:
	bin/make/ipa-agent.sh

# Builds the CBX-Runner.app and CBXAppStub.app and stages them
# to ./Products/ipa.
#
# Xcode Product > Build For > Testing stages apps to the same directory.
app-agent:
	bin/make/app-agent.sh

# Runs the Server (XCTest) unit tests.
#
# If you encounter a build error, use:
#
# $ XCPRETTY=0 make unit
#
# to diagnose.
#
# When running with xcpretty, a junit style report can be found in:
#
# build/reports/junit.xml
#
# Warnings are treated as errors. GCC_TREAT_WARNINGS_AS_ERRORS=YES
unit:
	bundle exec bin/test/unit.rb


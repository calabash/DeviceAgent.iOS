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
unit-tests:
	bundle update
	bundle exec bin/make/unit-tests.rb

ui-tests:
	bundle update
	bundle exec bin/make/ui-tests.rb

alerts-ui-tests:
	bundle update
	bundle exec bin/make/alerts-ui-tests.rb

# Makes the TestApp.app
test-app:
	bin/make/test-app.sh

# Makes the TestApp.ipa
test-ipa:
	bin/make/test-ipa.sh

# dylibs for testing dylib injection
gemuse:
	bin/make/gemuse-libs.sh

# update springboard alerts
# example of custom sim dir
# make update-alerts XCODE_CORE_SIM_DIR="/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS\ 10.3.simruntime"
update-alerts:
	cd tools/springboard-alerts && \
	bundle install && \
	bundle exec ruby update-alerts.rb "$(XCODE_CORE_SIM_DIR)"

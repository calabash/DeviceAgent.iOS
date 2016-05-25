#!/usr/bin/env bash

# At the moment, this is only required on Jenkins.
#
# The problem is that the xcodebuild process that launch the CBX-Runner
# stays alive after the job is completed and it then blocks simctl commands.
#
# If and when we transition to launching CBX-Runner without xcodebuild, this
# script can be removed.
#
# On Travis, a new VM is generated for each test, so there is no need to run
# this script on Travis.

xcrun pkill xcodebuild
xcrun pkill ibtoold

# Don't let a pkill failure cause the job to fail.
exit 0


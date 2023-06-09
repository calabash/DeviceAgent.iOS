#!/usr/bin/env bash
source bin/log.sh

set -e

banner "Preparing"

if [ $(gem list -i xcpretty) = "true" ] && [ "${XCPRETTY}" != "0" ]; then
  XC_PIPE='xcpretty -c'
else
  XC_PIPE='cat'
fi

DEFAULT_SIM_NAME="iPhone 14"
DEFAULT_SIM_OS_VERSION="16.4"
if [ "${1}" != "" ] && [ "${2}" != "" ]; then
  SIM_NAME=${1}
  SIM_OS_VERSION=${2}
else
  info "Simulator's name and OS version are not specified"
  info "Default Simulator settings will be used: ${DEFAULT_SIM_NAME} (${DEFAULT_SIM_OS_VERSION})"
  SIM_NAME=$DEFAULT_SIM_NAME
  SIM_OS_VERSION=$DEFAULT_SIM_OS_VERSION
fi

XC_SCHEME="DeviceAgentUnitTests"
XC_WORKSPACE="DeviceAgent.xcworkspace"

XC_UNIT_TESTS_BUILD_DIR="build/unit-tests"

COMMAND_LINE_BUILD=1 xcrun xcodebuild \
  -SYMROOT="${XC_UNIT_TESTS_BUILD_DIR}" \
  -derivedDataPath "${XC_UNIT_TESTS_BUILD_DIR}" \
  -workspace "${XC_WORKSPACE}" \
  -scheme "${XC_SCHEME}" \
  -destination "platform=iOS Simulator,name=${SIM_NAME},OS=${SIM_OS_VERSION}" \
  -sdk "iphonesimulator" \
  -configuration "Debug" \
  GCC_TREAT_WARNINGS_AS_ERRORS=NO \
  CLANG_ENABLE_CODE_COVERAGE=NO \
  OTHER_CFLAGS="-Xclang -Wno-switch" \
  test | $XC_PIPE

EXIT_CODE=${PIPESTATUS[0]}

if [ $EXIT_CODE != 0 ]; then
  error "Unit tests have failed"
  exit $EXIT_CODE
else
  info "All tests have passed"
fi
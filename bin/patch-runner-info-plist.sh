#!/usr/bin/env bash

set -e

source bin/log_functions.sh

if [ $# == 0 ]; then
  echo ""
  echo "Removes the leading new line from the CBX-Runner.app/Info.plist"
  echo "and resigns if the CBX-Runner was build for physical devices."
  echo ""
  echo "This script is suitable for xcode-build-phase Run Scripts and"
  echo "the make ipa-agent rule."
  echo ""
  echo "You should not never call this script directly."
  echo ""
  echo "Usage:"
  echo "   $0 path/to/CBX-Runner.app"
  exit 1;
fi

RUNNER="${1}"

if [ ! -e "${RUNNER}" ]; then
  error "Runner does not exit: ${RUNNER}"
  exit 1
fi

banner "Patching $(basename ${RUNNER})/Info.plist"

PLIST="${RUNNER}/Info.plist"

if [ "$(head -n 1 $PLIST)" == "" ]; then
  info "${PLIST} needs patching"
  TMP_PLIST=`mktemp`
  tail -n +2 "${PLIST}" > "${TMP_PLIST}"
  mv "${TMP_PLIST}" "${PLIST}"
else
  info "${PLIST} does not need patching"
  info "Nothing to do; exiting 0"
  exit 0
fi

info "Removed leading newline from ${PLIST}"

set +e
ARCHINFO=`xcrun lipo -info "${RUNNER}/XCTRunner"`
IGNORED=`echo ${ARCHINFO} | egrep -o "arm"`

if [ $? != 0 ]; then
  info "Simulator binary detected; skipping resign step"
  exit 0
fi
set -e

banner "Resigning"

DETAILS=`xcrun codesign --display --verbose=3 ${RUNNER} 2>&1`
CODE_SIGN_IDENTITY=`echo ${DETAILS} | egrep -o "iPhone Developer: .*\)" |  tr -d '\n'`

info "Will resign with original identity: ${CODE_SIGN_IDENTITY}"

echo ""

# --force to resign an app that is already signed
# --deep because the embedded CBX.xctest binary needs to be signed
# Preserve metadata because we don't want to have to provide a provisioning profile
xcrun codesign \
  --sign "${CODE_SIGN_IDENTITY}" \
  --force \
  --deep \
  --preserve-metadata=identifier,entitlements,requirements \
  ${RUNNER}


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
APPSTUB="${1}/../CBXAppStub.app"

if [ ! -e "${RUNNER}" ]; then
  error "Runner does not exist: ${RUNNER}"
  exit 1
fi

if [ ! -e "${APPSTUB}" ]; then
  error "CBXAppStub does not exist: ${APPSTUB}"
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

# $1 variable to store the identity in
# $2 the .app to extract the identity from
# extract_identity IDENTITY "${RUNNER}"
function extract_identity {
    DETAILS=`xcrun codesign --display --verbose=3 ${2} 2>&1`
    TMP=`echo ${DETAILS} | egrep -o "iPhone Developer: .*\)" |  tr -d '\n'`
    eval "$1=\"${TMP}\""
}

IDENTITY=""

if [ "${TERM}" = "dumb" ]; then
  XCODE_UI_BUILD=1
  info "Detected a build from Xcode UI"
else
  XCODE_UI_BUILD=0
  info "Detected a command line build"
fi

if [ "${XCODE_UI_BUILD}" = 0 ]; then
  if [ -n "${CODE_SIGN_IDENTITY}" ]; then
    info "CODE_SIGN_IDENTITY is set - will use ${CODE_SIGN_IDENTITY} to resign"
    IDENTITY="${CODE_SIGN_IDENTITY}"
  else
    extract_identity IDENTITY "${RUNNER}"
    info "Will resign with original identity: ${IDENTITY}"
  fi
else
  extract_identity IDENTITY "${RUNNER}"
  info "Will resign with original identity: ${IDENTITY}"
fi

echo ""

# --force to resign an app that is already signed
# --deep because the embedded CBX.xctest binary needs to be signed
# Preserve metadata because we don't want to have to provide a provisioning profile
xcrun codesign \
  --sign "${IDENTITY}" \
  --force \
  --deep \
  --preserve-metadata=identifier,entitlements,requirements \
  ${RUNNER}


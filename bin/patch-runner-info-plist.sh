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

if [ "${TERM}" = "dumb" ]; then
  XCODE_UI_BUILD=1
else
  XCODE_UI_BUILD=0
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

if [ "${XCODE_UI_BUILD}" = 0 ]; then
  info "Detected a command line build"

  if [ -n "${CODE_SIGN_IDENTITY}" ]; then
    info "CODE_SIGN_IDENTITY is set - will use ${CODE_SIGN_IDENTITY} to resign"
    IDENTITY="${CODE_SIGN_IDENTITY}"
  else
    extract_identity IDENTITY "${RUNNER}"
    info "Will resign with original identity: ${IDENTITY}"
  fi
else
  info "Detected a build from Xcode UI"

  # This is the default value.  It cannot be used because it might generate
  # 'ambigious match' errors when signing.
  if [ "${CODE_SIGN_IDENTITY}" = "iPhone Developer" ]; then

    # Try to extract the identity from the CBX-Runner.
    extract_identity IDENTITY "${RUNNER}"

    # Extracted an identity from the CBX-Runner
    if [ "${IDENTITY}" != "" ]; then
      info "Will resign with original identity: ${IDENTITY}"
    else

      # Typically, the runner has no identity and a bad bundle identifier.
      #
      # Identifier=com.apple.test.WRAPPEDPRODUCTNAME-Runner
      # Authority=Software Signing
      # Authority=Apple Code Signing Certification Authority
      # Authority=Apple Root CA
      info "Runner was not signed with a valid identity"
      info "Checking CBXAppStub"

      set +e
      xcrun codesign --display --verbose=3 "${APPSTUB}"
      if [ "$?" != "0" ]; then
        set -e
        info "CBXAppStub has no code siging information"

        IDENTITY="iPhone Developer"
        info "Will resign with default identity: ${IDENTITY}"
      else
        set -e
        extract_identity IDENTITY "${APPSTUB}"

        # Extracted an identity form the CBXAppStub
        if [ "${IDENTITY}" != "" ]; then
          info "Will resign with CBXAppStub identity: ${IDENTITY}"
        else
          info "CBXAppStub was not signed with an iPhone Developer identity"

          IDENTITY="iPhone Developer"
          info "Will resign with default identity: ${IDENTITY}"
        fi
      fi
    fi
  else

    # User updated the Xcode project with a specific identity
    info "CODE_SIGN_IDENTITY is set - will use ${CODE_SIGN_IDENTITY} to resign"
    IDENTITY="${CODE_SIGN_IDENTITY}"
  fi
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


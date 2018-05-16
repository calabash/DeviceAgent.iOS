#!/usr/bin/env bash

source bin/log.sh
source bin/ditto.sh
source bin/simctl.sh
source bin/xcode.sh

banner "Preparing"

hash xcpretty 2>/dev/null
if [ $? -eq 0 ] && [ "${XCPRETTY}" != "0" ]; then
  XC_PIPE='xcpretty -c'
else
  XC_PIPE='cat'
fi

info "Piping xcodebuild to ${XC_PIPE}"

set -e -o pipefail

if [ "${1}" = "arm" ]; then
  PLATFORM="iphoneos"
  ARCHES="armv7 armv7s arm64"
  PRODUCTS_SUBDIR="ipa"
  export VALID_ARCHS="armv7 armv7s arm64"
elif [ "${1}" = "x86" ]; then
  PLATFORM="iphonesimulator"
  ARCHES="i386 x86_64"
  PRODUCTS_SUBDIR="app"
else
  error "Usage: ${0} { arm | x86 }"
  exit 1
fi

info "Building for ${PLATFORM}: $ARCHS"
BUILD_DIR="build/TestApp/UITests"

INSTALL_DIR="Products/${PRODUCTS_SUBDIR}/TestApp/$(xcode_version)"
rm -rf "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}"

banner "Build For Testing"

xcrun xcodebuild \
  -derivedDataPath "${BUILD_DIR}" \
  -SYMROOT="${BUILD_DIR}" \
  -workspace DeviceAgent.xcworkspace \
  -scheme UITest \
  -configuration Debug \
  ARCH="${ARCHES}" \
  VALID_ARCHS="${ARCHES}" \
  -sdk "${PLATFORM}" \
  build-for-testing | $XC_PIPE

install_with_ditto \
  "${BUILD_DIR}/Build/Products/Debug-${PLATFORM}" \
  "${INSTALL_DIR}/UITests"

info "Done!"

#!/usr/bin/env bash

set -e

source bin/log_functions.sh
source bin/plist-buddy.sh
source bin/copy-with-ditto.sh

banner "Preparing"

if [ "${XCPRETTY}" = "0" ]; then
  USE_XCPRETTY=
else
  USE_XCPRETTY=`which xcpretty | tr -d '\n'`
fi

if [ ! -z ${USE_XCPRETTY} ]; then
  XC_PIPE='xcpretty -c'
else
  XC_PIPE='cat'
fi

XC_TARGET="DeviceAgent"
XC_PROJECT="DeviceAgent.xcodeproj"
XC_CONFIG=Debug

XC_BUILD_DIR="build/ipa/DeviceAgent"
mkdir -p "${XC_BUILD_DIR}"

INSTALL_DIR="Products/ipa/DeviceAgent"
rm -rf "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}"

APP="AppStub.app"
DSYM="${APP}.dSYM"
IPA="AppStub.ipa"
RUNNER="DeviceAgent-Runner.app"
RUNNER_IPA="DeviceAgent-Runner.ipa"

INSTALLED_APP="${INSTALL_DIR}/${APP}"
INSTALLED_DSYM="${INSTALL_DIR}/${DSYM}"
INSTALLED_IPA="${INSTALL_DIR}/${IPA}"
INSTALLED_RUNNER="${INSTALL_DIR}/${RUNNER}"
INSTALLED_RUNNER_IPA="${INSTALL_DIR}/${RUNNER_IPA}"

rm -rf "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}"

info "Prepared install directory ${INSTALL_DIR}"

BUILD_PRODUCTS_DIR="${XC_BUILD_DIR}/Build/Products/${XC_CONFIG}-iphoneos"
BUILD_PRODUCTS_APP="${BUILD_PRODUCTS_DIR}/${APP}"
BUILD_PRODUCTS_DSYM="${BUILD_PRODUCTS_DIR}/${DSYM}"
BUILD_PRODUCTS_RUNNER="${BUILD_PRODUCTS_DIR}/${RUNNER}"

rm -rf "${BUILD_PRODUCTS_APP}"
rm -rf "${BUILD_PRODUCTS_DSYM}"
rm -rf "${BUILD_PRODUCTS_RUNNER}"
mkdir -p "${BUILD_PRODUCTS_DIR}"

info "Prepared archive directory"

banner "Building ${IPA}"

COMMAND_LINE_BUILD=1 xcrun xcodebuild \
  -SYMROOT="${XC_BUILD_DIR}" \
  BUILT_PRODUCTS_DIR="${BUILD_PRODUCTS_DIR}" \
  TARGET_BUILD_DIR="${BUILD_PRODUCTS_DIR}" \
  DWARF_DSYM_FOLDER_PATH="${BUILD_PRODUCTS_DIR}" \
  -project "${XC_PROJECT}" \
  -target "${XC_TARGET}" \
  -configuration "${XC_CONFIG}" \
  -sdk iphoneos \
  ARCHS="armv7 armv7s arm64" \
  VALID_ARCHS="armv7 armv7s arm64" \
  ONLY_ACTIVE_ARCH=NO \
  GCC_TREAT_WARNINGS_AS_ERRORS=YES \
  build | $XC_PIPE

EXIT_CODE=${PIPESTATUS[0]}

if [ $EXIT_CODE != 0 ]; then
  error "Building ipa failed."
  exit $EXIT_CODE
else
  info "Building ipa succeeded."
fi

bin/patch-runner-info-plist.sh "${BUILD_PRODUCTS_APP}" "${BUILD_PRODUCTS_RUNNER}"

banner "Installing ipa"

ditto_or_exit "${BUILD_PRODUCTS_APP}" "${INSTALLED_APP}"
info "Installed ${INSTALLED_APP}"

PAYLOAD_DIR="${INSTALL_DIR}/tmp/app/Payload"
mkdir -p "${PAYLOAD_DIR}"

ditto_or_exit "${INSTALLED_APP}" "${PAYLOAD_DIR}/${APP}"

xcrun ditto -ck --rsrc --sequesterRsrc --keepParent \
  "${PAYLOAD_DIR}" \
  "${INSTALLED_IPA}"

info "Installed ${INSTALLED_IPA}"

banner "Installing runner ipa"

ditto_or_exit "${BUILD_PRODUCTS_RUNNER}" "${INSTALLED_RUNNER}"
info "Installed ${INSTALLED_RUNNER}"

PAYLOAD_DIR="${INSTALL_DIR}/tmp/runner/Payload"
mkdir -p "${PAYLOAD_DIR}"

ditto_or_exit "${INSTALLED_RUNNER}" "${PAYLOAD_DIR}/${RUNNER}"

xcrun ditto -ck --rsrc --sequesterRsrc --keepParent \
  "${PAYLOAD_DIR}" \
  "${INSTALLED_RUNNER_IPA}"

info "Installed ${INSTALLED_RUNNER_IPA}"

ZIP_TARGET="${INSTALL_DIR}/${RUNNER}.zip"

xcrun ditto -ck --rsrc --sequesterRsrc --keepParent \
  "${INSTALLED_RUNNER}" \
  "${ZIP_TARGET}"

info "Installed ${ZIP_TARGET}"

ditto_or_exit "${BUILD_PRODUCTS_DSYM}" "${INSTALLED_DSYM}"
info "Installed ${INSTALLED_DSYM}"

banner "Test"

APP_BUNDLE_VERSION=""
plist_read_key "${INSTALLED_APP}/Info.plist" \
  "CFBundleVersion" \
  APP_BUNDLE_VERSION

APP_SHORT_VERSION=""
plist_read_key "${INSTALLED_APP}/Info.plist" \
  "CFBundleShortVersionString" \
  APP_SHORT_VERSION

expect_version_equal "${APP_BUNDLE_VERSION}" \
  "${INSTALLED_RUNNER}/Info.plist" "CFBundleVersion"

expect_version_equal "${APP_SHORT_VERSION}" \
  "${INSTALLED_RUNNER}/Info.plist" "CFBundleShortVersionString"

expect_version_equal "${APP_BUNDLE_VERSION}" \
  "${INSTALLED_RUNNER}/PlugIns/DeviceAgent.xctest/Info.plist" "CFBundleVersion"

expect_version_equal "${APP_SHORT_VERSION}" \
  "${INSTALLED_RUNNER}/PlugIns/DeviceAgent.xctest/Info.plist" "CFBundleShortVersionString"

banner "Info"

info "Installed ${INSTALLED_APP}"
info "Installed ${INSTALLED_IPA}"
info "Installed ${INSTALLED_RUNNER}"
info "Installed ${INSTALLED_RUNNER_IPA}"
info "Installed ${INSTALLED_DSYM}"
info "Installed ${ZIP_TARGET}"

echo ""

info "CFBundleShortVersionString: ${APP_SHORT_VERSION}"
info "           CFBundleVersion: ${APP_BUNDLE_VERSION}"

echo ""

info "Done!"


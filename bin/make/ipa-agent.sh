#!/usr/bin/env bash

source bin/log.sh
source bin/ditto.sh
source bin/plist-buddy.sh
source bin/simctl.sh

set -e

banner "Preparing"

if [ $(gem list -i xcpretty) = "true" ] && [ "${XCPRETTY}" != "0" ]; then
  XC_PIPE='xcpretty -c'
else
  XC_PIPE='cat'
fi

XC_WORKSPACE="DeviceAgent.xcworkspace"
XC_SCHEME="DeviceAgent"
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
  -scheme "${XC_SCHEME}" \
  -workspace "${XC_WORKSPACE}" \
  -SYMROOT="${XC_BUILD_DIR}" \
  -derivedDataPath "${XC_BUILD_DIR}" \
  -configuration "${XC_CONFIG}" \
  -sdk iphoneos \
  ARCHS="arm64" \
  VALID_ARCHS="arm64" \
  ONLY_ACTIVE_ARCH=NO \
  GCC_TREAT_WARNINGS_AS_ERRORS=YES \
  build-for-testing | $XC_PIPE

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


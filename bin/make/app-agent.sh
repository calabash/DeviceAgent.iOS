#!/usr/bin/env bash

source bin/log.sh
source bin/ditto.sh
source bin/plist-buddy.sh
source bin/simctl.sh
source bin/xcode.sh

set -e

banner "Preparing"

if [ $(gem list -i xcpretty) = "true" ] && [ "${XCPRETTY}" != "0" ]; then
  XC_PIPE='xcpretty -c'
else
  XC_PIPE='cat'
fi

XC_TARGET="DeviceAgent"
XC_PROJECT="DeviceAgent.xcodeproj"
XC_CONFIG=Debug

XC_BUILD_DIR="build/app/DeviceAgent"
mkdir -p "${XC_BUILD_DIR}"

INSTALL_DIR=Products/app/DeviceAgent
rm -rf "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}"

APP="AppStub.app"
DSYM="${APP}.dSYM"
RUNNER="DeviceAgent-Runner.app"

INSTALLED_APP="${INSTALL_DIR}/${APP}"
INSTALLED_DSYM="${INSTALL_DIR}/${DSYM}"
INSTALLED_RUNNER="${INSTALL_DIR}/${RUNNER}"

info "Prepared install directory ${INSTALL_DIR}"

BUILD_PRODUCTS_DIR="${XC_BUILD_DIR}/Build/Products/${XC_CONFIG}-iphonesimulator"
BUILD_PRODUCTS_APP="${BUILD_PRODUCTS_DIR}/${APP}"
BUILD_PRODUCTS_DSYM="${BUILD_PRODUCTS_DIR}/${DSYM}"
BUILD_PRODUCTS_RUNNER="${BUILD_PRODUCTS_DIR}/${RUNNER}"

rm -rf "${BUILD_PRODUCTS_APP}"
rm -rf "${BUILD_PRODUCTS_DSYM}"
rm -rf "${BUILD_PRODUCTS_RUNNER}"
mkdir -p "${BUILD_PRODUCTS_DIR}"

info "Prepared build directory ${XC_BUILD_DIR}"

banner "Building ${APP}"

COMMAND_LINE_BUILD=1 xcrun xcodebuild  \
  -SYMROOT="${XC_BUILD_DIR}" \
  BUILT_PRODUCTS_DIR="${BUILD_PRODUCTS_DIR}" \
  TARGET_BUILD_DIR="${BUILD_PRODUCTS_DIR}" \
  DWARF_DSYM_FOLDER_PATH="${BUILD_PRODUCTS_DIR}" \
  -project "${XC_PROJECT}" \
  -target "${XC_TARGET}" \
  -configuration "${XC_CONFIG}" \
  -sdk iphonesimulator \
  ARCHS="x86_64" \
  VALID_ARCHS="x86_64" \
  ONLY_ACTIVE_ARCH=NO \
  GCC_TREAT_WARNINGS_AS_ERRORS=YES \
  build | $XC_PIPE

EXIT_CODE=${PIPESTATUS[0]}

if [ $EXIT_CODE != 0 ]; then
  error "Building app failed."
  exit $EXIT_CODE
else
  info "Building app succeeded."
fi

if [ "$(xcode_gte_9)" = "true" ]; then
  banner "Patching for Xcode >= 9"

  XCTEST_BUNDLE="${XC_TARGET}.xctest"
  BUILD_PRODUCTS_XCTEST="${BUILD_PRODUCTS_DIR}/${XCTEST_BUNDLE}"
  RUNNER_PLUGINS="${BUILD_PRODUCTS_RUNNER}/PlugIns"
  mkdir -p "${RUNNER_PLUGINS}"

  ditto_or_exit "${BUILD_PRODUCTS_XCTEST}" "${RUNNER_PLUGINS}/${XCTEST_BUNDLE}"

  XCTEST_DSYM="${XCTEST_BUNDLE}.dSYM"
  BUILD_PRODUCTS_XCTEST_DSYM="${BUILD_PRODUCTS_DIR}/${XCTEST_DSYM}"

  ditto_or_exit "${BUILD_PRODUCTS_XCTEST_DSYM}" "${RUNNER_PLUGINS}/${XCTEST_DSYM}"
fi

bin/patch-runner-info-plist.sh "${BUILD_PRODUCTS_APP}" "${BUILD_PRODUCTS_RUNNER}"

banner "Installing ${APP}"

ditto_or_exit "${BUILD_PRODUCTS_APP}" "${INSTALLED_APP}"
info "Installed ${INSTALLED_APP}"

ditto_or_exit "${BUILD_PRODUCTS_DSYM}" "${INSTALLED_DSYM}"
info "Installed ${INSTALLED_DSYM}"

ditto_or_exit "${BUILD_PRODUCTS_RUNNER}" "${INSTALLED_RUNNER}"
info "Installed ${INSTALLED_RUNNER}"

ZIP_TARGET="${INSTALLED_RUNNER}.zip"
xcrun ditto -ck --rsrc --sequesterRsrc --keepParent \
  "${INSTALLED_RUNNER}" \
  "${ZIP_TARGET}"
info "Installed ${ZIP_TARGET}"

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
info "Installed ${INSTALLED_RUNNER}"
info "Installed ${INSTALLED_DSYM}"
info "Installed ${ZIP_TARGET}"

echo ""

info "CFBundleShortVersionString: ${APP_SHORT_VERSION}"
info "           CFBundleVersion: ${APP_BUNDLE_VERSION}"

echo ""

info "Done!"


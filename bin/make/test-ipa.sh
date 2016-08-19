#!/usr/bin/env bash

source bin/log_functions.sh
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

XC_TARGET="TestApp"
XC_PROJECT="DeviceAgent.xcodeproj"
XC_CONFIG=Debug

XC_BUILD_DIR="build/ipa/TestApp"
mkdir -p "${XC_BUILD_DIR}"

INSTALL_DIR="Products/ipa/TestApp"
rm -rf "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}"

APP="TestApp.app"
DSYM="${APP}.dSYM"
IPA="TestApp.ipa"

INSTALLED_APP="${INSTALL_DIR}/${APP}"
INSTALLED_DSYM="${INSTALL_DIR}/${DSYM}"
INSTALLED_IPA="${INSTALL_DIR}/${IPA}"

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

if [ -z "${CODE_SIGN_IDENTITY}" ]; then
  CODE_SIGN_IDENTITY="iPhone Developer"
fi

info "CODE_SIGN_IDENTITY is ${CODE_SIGN_IDENTITY}"

COMMAND_LINE_BUILD=1 xcrun xcodebuild \
  CODE_SIGN_IDENTITY="${CODE_SIGN_IDENTITY}" \
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
  build | $XC_PIPE

EXIT_CODE=${PIPESTATUS[0]}

if [ $EXIT_CODE != 0 ]; then
  error "Building ipa failed."
  exit $EXIT_CODE
else
  info "Building ipa succeeded."
fi

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

banner "IPA Code Signing Details"

DETAILS=`xcrun codesign --display --verbose=2 ${INSTALLED_APP} 2>&1`

echo "$(tput setaf 4)$DETAILS$(tput sgr0)"

echo ""

CAL_VERSION=`xcrun strings "${INSTALLED_APP}/${XC_TARGET}" | grep -E 'CALABASH VERSION' | head -n 1`
info "${CAL_VERSION}"

echo ""

info "Done!"


#!/usr/bin/env bash

set -e

source bin/log_functions.sh
source bin/copy-with-ditto.sh

function usage {
  echo ""
  echo "Usage:"
  echo " ${0} path/to/calabash.framework"
  echo ""
  exit 1
}

if [ "${1}" = "" ]; then
  usage
fi

if [ -d "${1}" ]; then
  CALABASH_FRAMEWORK="${1}"
else
  error "calabash.framework does not exist at:"
  error "  ${1}"
  usage
  exit 1
fi

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

XC_TARGET="UnitTestApp"
XC_PROJECT="CBXDriver.xcodeproj"
XC_CONFIG=Debug

XC_BUILD_DIR="build/app/UnitTestApp"
mkdir -p "${XC_BUILD_DIR}"

INSTALL_DIR="Products/app/UnitTestApp-cal"
rm -rf "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}"

APP="UnitTestApp.app"
DSYM="${APP}.dSYM"

INSTALLED_APP="${INSTALL_DIR}/${APP}"
INSTALLED_DSYM="${INSTALL_DIR}/${DSYM}"

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
  OTHER_LDFLAGS="-ObjC -lz -framework Reveal -framework Security -force_load ${CALABASH_FRAMEWORK}/calabash" \
  -sdk iphonesimulator \
  ARCHS="i386 x86_64" \
  VALID_ARCHS="i386 x86_64" \
  ONLY_ACTIVE_ARCH=NO \
  build | $XC_PIPE

EXIT_CODE=${PIPESTATUS[0]}

if [ $EXIT_CODE != 0 ]; then
  error "Building app failed."
  exit $EXIT_CODE
else
  info "Building app succeeded."
fi

banner "Installing ${APP}"

ditto_or_exit "${BUILD_PRODUCTS_APP}" "${INSTALLED_APP}"
info "Installed ${INSTALLED_APP}"

ditto_or_exit "${BUILD_PRODUCTS_DSYM}" "${INSTALLED_DSYM}"
info "Installed ${INSTALLED_DSYM}"

info "Done!"

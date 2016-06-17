#!/usr/bin/env bash

set -e

function info {
  echo "$(tput setaf 2)INFO: $1$(tput sgr0)"
}

function error {
  echo "$(tput setaf 1)ERROR: $1$(tput sgr0)"
}

function banner {
  echo ""
  echo "$(tput setaf 5)######## $1 #######$(tput sgr0)"
  echo ""
}

function ditto_or_exit {
  ditto "${1}" "${2}"
  if [ "$?" != 0 ]; then
    error "Could not copy:"
    error "  source: ${1}"
    error "  target: ${2}"
    if [ ! -e "${1}" ]; then
      error "The source file does not exist"
      error "Did a previous xcodebuild step fail?"
    fi
    error "Exiting 1"
    exit 1
  fi
}

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

XC_TARGET="XCUITestDriver"
XC_PROJECT="CBXDriver.xcodeproj"
XC_CONFIG=Debug

XC_BUILD_DIR="build/app/DeviceAgent"
mkdir -p "${XC_BUILD_DIR}"

INSTALL_DIR=Products/app/DeviceAgent
rm -rf "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}"

APP="CBXAppStub.app"
DSYM="${APP}.dSYM"
RUNNER="CBX-Runner.app"

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

bin/patch-runner-info-plist.sh "${BUILD_PRODUCTS_RUNNER}"

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

info "Done!"


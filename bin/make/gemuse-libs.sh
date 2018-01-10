#!/usr/bin/env bash

source bin/log.sh
source bin/ditto.sh
source bin/simctl.sh

set -e

banner "Preparing"

hash xcpretty 2>/dev/null
if [ $? -eq 0 ] && [ "${XCPRETTY}" != "0" ]; then
  XC_PIPE='xcpretty -c'
else
  XC_PIPE='cat'
fi

if [ "${1}" = "--upload" ]; then
  UPLOAD_TO_S3="1"
fi

XC_WORKSPACE="DeviceAgent.xcworkspace"
XC_CONFIG=Release

XC_BUILD_DIR="build/GemuseBouche"
ARM_PRODUCT_DIR="${XC_BUILD_DIR}/Build/Products/Release-iphoneos"
SIM_PRODUCT_DIR="${XC_BUILD_DIR}/Build/Products/Release-iphonesimulator"
mkdir -p "${ARM_PRODUCT_DIR}"
mkdir -p "${SIM_PRODUCT_DIR}"
info "Prepared build directory ${XC_BUILD_DIR}"

INSTALL_DIR="Products/lib/GemuseBouche"
rm -rf "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}"
info "Prepared install directory ${INSTALL_DIR}"

banner "Building GemuseBouche"

function build_libs_for_arch {
  if [ "${1}" = "sim" ]; then
    local arches="i386 x86_64"
    local sdk="iphonesimulator"
  else
    local arches="armv7 armv7s arm64"
    local sdk="iphoneos"
  fi

  COMMAND_LINE_BUILD=1 xcrun xcodebuild  \
    -workspace "${XC_WORKSPACE}" \
    -scheme "GemuseBouche" \
    -derivedDataPath "${XC_BUILD_DIR}" \
    -configuration "${XC_CONFIG}" \
    -sdk "${sdk}" \
    ARCHS="${arches}" \
    VALID_ARCHS="${arches}" \
    ONLY_ACTIVE_ARCH=NO \
    build | $XC_PIPE

  EXIT_CODE=${PIPESTATUS[0]}

  if [ $EXIT_CODE != 0 ]; then
    error "Building libraries failed."
    exit $EXIT_CODE
  fi
}

build_libs_for_arch "arm"
build_libs_for_arch "sim"

function fat_lib_with_lipo {
  local arm_lib="${ARM_PRODUCT_DIR}/${1}.dylib"
  local sim_lib="${SIM_PRODUCT_DIR}/${1}.dylib"
  local fat_lib="${INSTALL_DIR}/${1}.dylib"
  xcrun lipo -create "${arm_lib}" "${sim_lib}" \
    -output "${fat_lib}"

  "${HOME}/.calabash/calabash-codesign/apple/resign-dylib.sh" \
    "${fat_lib}"

  local version=$(xcrun strings "${fat_lib}" | \
    grep -E 'kCBXLibVersion' |  head -n1 | cut -f2- -d":")
  info "Installed version $version to ${fat_lib}"

  if [ "${UPLOAD_TO_S3}" = "1" ]; then
    aws s3 cp "${fat_lib}" \
      "s3://calabash-files/dylibs/to-test-injection/${1}.dylib"
  fi
}

fat_lib_with_lipo "libCucurbits"
fat_lib_with_lipo "libBetaVulgaris"
fat_lib_with_lipo "libBrassica"

info "Done!"

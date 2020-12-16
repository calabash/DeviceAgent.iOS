#!/usr/bin/env bash

source bin/log.sh
source bin/ditto.sh
source bin/simctl.sh

set -e

banner "Preparing"

if [ $(gem list -i xcpretty) = "true" ] && [ "${XCPRETTY}" != "0" ]; then
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

APP="TestApp.app"
DSYM="${APP}.dSYM"
IPA="TestApp.ipa"

INSTALLED_APP="${INSTALL_DIR}/${APP}"
INSTALLED_DSYM="${INSTALL_DIR}/${DSYM}"
INSTALLED_IPA="${INSTALL_DIR}/${IPA}"

BUILD_PRODUCTS_DIR="${XC_BUILD_DIR}/Build/Products/${XC_CONFIG}-iphoneos"
BUILD_PRODUCTS_APP="${BUILD_PRODUCTS_DIR}/${APP}"
BUILD_PRODUCTS_DSYM="${BUILD_PRODUCTS_DIR}/${DSYM}"

rm -rf "${BUILD_PRODUCTS_APP}"
rm -rf "${BUILD_PRODUCTS_DSYM}"
mkdir -p "${BUILD_PRODUCTS_DIR}"

info "Prepared archive directory"

if [ "${PREPARE_TC_ONLY}" != "1" ]; then
  rm -rf "${INSTALL_DIR}"
  mkdir -p "${INSTALL_DIR}"

  info "Prepared install directory ${INSTALL_DIR}"

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
    ARCHS="arm64" \
    VALID_ARCHS="arm64" \
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

  install_with_ditto "${BUILD_PRODUCTS_APP}" "${INSTALLED_APP}"

  PAYLOAD_DIR="${INSTALL_DIR}/tmp/app/Payload"
  mkdir -p "${PAYLOAD_DIR}"

  ditto_or_exit "${INSTALLED_APP}" "${PAYLOAD_DIR}/${APP}"

  ditto_to_zip "${PAYLOAD_DIR}" "${INSTALLED_IPA}"
  install_with_ditto "${INSTALLED_IPA}" "${INSTALL_DIR}/DeviceAgent-device.ipa"
  ditto_to_zip "${INSTALLED_APP}" "${INSTALL_DIR}/DeviceAgent-device.app.zip"

  install_with_ditto "${BUILD_PRODUCTS_DSYM}" "${INSTALLED_DSYM}"
  install_with_ditto "${BUILD_PRODUCTS_DSYM}" \
    "${INSTALL_DIR}/DeviceAgent-device.app.dSYM"

  banner "IPA Code Signing Details"

  DETAILS=`xcrun codesign --display --verbose=2 ${INSTALLED_APP} 2>&1`

  echo "$(tput setaf 4)$DETAILS$(tput sgr0)"

  echo ""

  CAL_VERSION=`xcrun strings "${INSTALLED_APP}/${XC_TARGET}" | grep -E 'CALABASH VERSION' | head -n 1`
  info "${CAL_VERSION}"

  echo ""
fi
banner "Preparing for XTC Submit"

TC_DIR="testcloud-submit"
rm -rf "${TC_DIR}"
mkdir -p "${TC_DIR}"

install_with_ditto cucumber/features "${TC_DIR}/features"
install_with_ditto cucumber/config/xtc-profiles.yml "${TC_DIR}/cucumber.yml"
install_with_ditto cucumber/config/xtc-hooks.rb \
  "${TC_DIR}/features/support/01_launch.rb"
install_with_ditto "${INSTALLED_IPA}" "${TC_DIR}/"
install_with_ditto "${INSTALLED_DSYM}" "${TC_DIR}/${DSYM}"
mkdir -p "${TC_DIR}/.xtc"

rm -rf "${TC_DIR}/features/.idea"

cat >"${TC_DIR}/Gemfile" <<EOF
source "https://rubygems.org"

gem "calabash-cucumber"
gem "cucumber", "2.99.0"
gem "json", "1.8.6"
gem "rspec", "~> 3.0"
EOF

info "Wrote ${TC_DIR}/Gemfile with contents"
cat "${TC_DIR}/Gemfile"

info "Done!"

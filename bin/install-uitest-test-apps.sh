#!/usr/bin/env bash

source bin/log.sh
source bin/ditto.sh

if [ ! -x "$(command -v greadlink)" ]; then
  error "This script requires greadlink which can be installed with homebrew"
  error "$ brew update"
  error "$ brew install coreutils"
fi

INSTALL_DIR="$(greadlink -f ../../xtc/test-cloud-test-apps/uitest-test-apps/iOS)"

if [ ! -d $INSTALL_DIR ]; then
  error "Expected the test-cloud-test-apps repo to be installed here:"
  error "  $INSTALL_DIR"
  exit 1
fi

set -e

make test-app
make test-ipa

banner "Installing to UITest Apps"

install_with_ditto \
  "Products/app/TestApp/DeviceAgent-sim.app.zip" \
  "${INSTALL_DIR}/DeviceAgent-sim.app.zip"

install_with_ditto \
  "Products/app/TestApp/DeviceAgent-sim.app.dSYM" \
  "${INSTALL_DIR}/DeviceAgent-sim.app.dSYM"

install_with_ditto \
  "Products/ipa/TestApp/DeviceAgent-device.app.dSYM" \
  "${INSTALL_DIR}/DeviceAgent-device.app.dSYM"

install_with_ditto \
  "Products/ipa/TestApp/DeviceAgent-device.app.zip" \
  "${INSTALL_DIR}/CalWebView-device.app.zip"

install_with_ditto \
  "Products/ipa/TestApp/DeviceAgent-device.ipa" \
  "${INSTALL_DIR}/DeviceAgent-device.ipa"

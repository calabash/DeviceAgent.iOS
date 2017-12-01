#!/usr/bin/env bash

source bin/log.sh
source bin/ditto.sh

if [ ! -x "$(command -v greadlink)" ]; then
  error "This script requires greadlink which can be installed with homebrew"
  error "$ brew update"
  error "$ brew install coreutils"
  exit 1
fi

INSTALL_DIR="$(greadlink -f ../calabash-ios/calabash-cucumber/test/cucumber/aut)"

if [ ! -d $INSTALL_DIR ]; then
  error "Expected the calabash-ios to be installed here:"
  error "  $INSTALL_DIR"
  exit 1
fi

set -e

make test-app
make test-ipa

banner "Installing to Calabash iOS Gem"

function install_app {
  if [ -d "${2}" ]; then
    rm -rf "${2}"
  else
    error "Expected .app to exist at:"
    error "  ${2}"
    exit 1
  fi
  install_with_ditto "${1}" "${2}"
}

function install_ipa {
  if [ -e "${2}" ]; then
    rm -f "${2}"
  else
    error "Expected .ipa to exist at:"
    error "  ${2}"
    exit 1
  fi
  install_with_ditto "${1}" "${2}"
}

function install_dsym {
  if [ -d "${2}" ]; then
    rm -rf "${2}"
  else
    error "Expected .app.dSYM to exist at:"
    error "  ${2}"
    exit 1
  fi
  install_with_ditto "${1}" "${2}"
}

install_app \
  "Products/app/TestApp/TestApp.app" \
  "${INSTALL_DIR}/sim/TestApp.app"

install_app \
  "Products/ipa/TestApp/TestApp.app" \
  "${INSTALL_DIR}/ipa/TestApp.app"

INSTALL_DIR="$(greadlink -f ../calabash-ios-server/cucumber/device-agent-test-app/)"

if [ ! -d $INSTALL_DIR ]; then
  error "Expected the calabash-ios to be installed here:"
  error "  $INSTALL_DIR"
  exit 1
fi

install_app \
  "Products/app/TestApp/TestApp.app" \
  "${INSTALL_DIR}/TestApp.app"

install_ipa \
  "Products/ipa/TestApp/TestApp.ipa" \
  "${INSTALL_DIR}/TestApp.ipa"

install_dsym \
  "Products/ipa/TestApp/TestApp.app.dSYM" \
  "${INSTALL_DIR}/TestApp.app.dSYM"

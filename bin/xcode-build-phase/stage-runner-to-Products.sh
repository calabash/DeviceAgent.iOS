#!/usr/bin/env bash

# Stages CBX-Runner.app built by Xcode to ./Products/

set -e

function info {
  echo "INFO: $1"
}

function error {
  echo "ERROR: $1"
}

function banner {
  echo ""
  echo "######## $1 #######"
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

# Command line builds already stage binaries to Products/
if [ ! -z $COMMAND_LINE_BUILD ]; then
  exit 0
fi

if [ ${EFFECTIVE_PLATFORM_NAME} = "-iphoneos" ]; then
  APP_TARGET_DIR="${SOURCE_ROOT}/Products/ipa/DeviceAgent"
else
  APP_TARGET_DIR="${SOURCE_ROOT}/Products/app/DeviceAgent"
fi

banner "Preparing"

info "Xcode build detected; will stage binary to $APP_TARGET_DIR"

APP_NAME="${PRODUCT_NAME}-Runner.app"
APP_SOURCE_PATH="${CONFIGURATION_BUILD_DIR}/${APP_NAME}"
APP_TARGET_PATH="${APP_TARGET_DIR}/${APP_NAME}"

rm -rf "${APP_TARGET_DIR}/tmp/runner"
mkdir -p "${APP_TARGET_DIR}/tmp/runner"

ditto_or_exit "${APP_SOURCE_PATH}" "${APP_TARGET_PATH}"
info "Copied .app to ${APP_TARGET_DIR}/${APP_NAME}"

bin/patch-runner-info-plist.sh "${APP_TARGET_PATH}"

ZIP_PATH="${APP_TARGET_PATH}.zip"
  xcrun ditto -ck --rsrc --sequesterRsrc --keepParent \
    "${APP_TARGET_PATH}" \
    "${ZIP_PATH}"

if [ ${EFFECTIVE_PLATFORM_NAME} = "-iphoneos" ]; then

  banner "Creating ipa"

  PAYLOAD_DIR="${APP_TARGET_DIR}/tmp/runner/Payload"
  mkdir -p "${PAYLOAD_DIR}"
  PAYLOAD_APP="${PAYLOAD_DIR}/${APP_NAME}"
  ditto_or_exit "${APP_TARGET_PATH}" "${PAYLOAD_APP}"

  IPA_PATH="${APP_TARGET_DIR}/${PRODUCT_NAME}-Runner.ipa"

  info "Zipping .app to ${IPA_PATH}"
  xcrun ditto -ck --rsrc --sequesterRsrc --keepParent \
    "${PAYLOAD_DIR}" \
    "${IPA_PATH}"
  info "Installed .ipa to ${IPA_PATH}"
fi

info "Done!"


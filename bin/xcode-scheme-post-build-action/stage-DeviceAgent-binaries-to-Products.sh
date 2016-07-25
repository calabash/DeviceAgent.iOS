#!/usr/bin/env bash

# Stages CBX-Runner.app built by Xcode to ./Products/
# Called from XCUITestDriver scheme Build Post Action

set -e

# Cannot source from bin/log_functions.sh
function info {
  echo "INFO: $1"
}

# Cannot source from bin/log_functions.sh
function error {
  echo "ERROR: $1"
}

# Cannot source from bin/log_functions.sh
function banner {
  echo ""
  echo "######## $1 #######"
  echo ""
}

# Cannot source from bin/copy-with-ditto.sh
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
  INSTALL_DIR="${SOURCE_ROOT}/Products/ipa/DeviceAgent"
else
  INSTALL_DIR="${SOURCE_ROOT}/Products/app/DeviceAgent"
fi

function create_ipa {
  LOCAL_PAYLOAD_DIR="${1}"
  LOCAL_APP_NAME="${2}" # No extension
  LOCAL_SOURCE_APP="${3}"

  mkdir -p "${LOCAL_PAYLOAD_DIR}"
  PAYLOAD_APP="${LOCAL_PAYLOAD_DIR}/${LOCAL_APP_NAME}.app"
  ditto_or_exit "${LOCAL_SOURCE_APP}" "${PAYLOAD_APP}"

  IPA_PATH="${INSTALL_DIR}/${LOCAL_APP_NAME}.ipa"

  info "Zipping .app to ${IPA_PATH}"
  xcrun ditto -ck --rsrc --sequesterRsrc --keepParent \
    "${PAYLOAD_DIR}" \
    "${IPA_PATH}"
  info "Installed .ipa to ${IPA_PATH}"
}

banner "Preparing"

info "Xcode build detected; will stage binaries to $INSTALL_DIR"

info "Cleaned install directory: ${INSTALL_DIR}"
rm -rf "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}"


RUNNER_NAME="${PRODUCT_NAME}-Runner"
RUNNER_SOURCE_APP="${CONFIGURATION_BUILD_DIR}/${RUNNER_NAME}.app"
RUNNER_TARGET_APP="${INSTALL_DIR}/${RUNNER_NAME}.app"

APPSTUB_NAME="${TEST_TARGET_NAME}"
APPSTUB_SOURCE_APP="${CONFIGURATION_BUILD_DIR}/${APPSTUB_NAME}.app"
APPSTUB_TARGET_APP="${INSTALL_DIR}/${APPSTUB_NAME}.app"

banner "Installing the ${RUNNER_NAME}.app"

ditto_or_exit "${RUNNER_SOURCE_APP}" "${RUNNER_TARGET_APP}"
info "Copied .app to ${RUNNER_TARGET_APP}"

bin/patch-runner-info-plist.sh "${RUNNER_TARGET_APP}"

# Required for iOSDeviceManager packaging.
RUNNER_ZIP_PATH="${RUNNER_TARGET_APP}.zip"
  xcrun ditto -ck --rsrc --sequesterRsrc --keepParent \
    "${RUNNER_TARGET_APP}" \
    "${RUNNER_ZIP_PATH}"

banner "Installing the ${APPSTUB_NAME}.app"
ditto_or_exit "${APPSTUB_SOURCE_APP}" "${APPSTUB_TARGET_APP}"
info "Copied .app to ${RUNNER_TARGET_APP}"

if [ ${EFFECTIVE_PLATFORM_NAME} = "-iphoneos" ]; then

  banner "Creating ${RUNNER_NAME}.ipa"
  PAYLOAD_DIR="${INSTALL_DIR}/tmp/runner/Payload"
  create_ipa "${PAYLOAD_DIR}" "${RUNNER_NAME}" "${RUNNER_TARGET_APP}"

  banner "Creating ${APPSTUB_NAME}.ipa"
  PAYLOAD_DIR="${INSTALL_DIR}/tmp/appstub/Payload"
  create_ipa "${PAYLOAD_DIR}" "${APPSTUB_NAME}" "${APPSTUB_TARGET_APP}"
fi

info "Done!"


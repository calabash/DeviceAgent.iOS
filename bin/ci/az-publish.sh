#!/usr/bin/env bash

source bin/xcode.sh

set -eo pipefail

# $1 => SOURCE PATH
# $2 => TARGET NAME
function azupload {
  az storage blob upload \
    --container-name ios-device-agent \
    --file "${1}" \
    --name "${2}"
  echo "${1} artifact uploaded with name ${2}"
}

# Pipeline Variables are set through the AzDevOps UI
# See also the ./azdevops-pipeline.yml
if [[ -z "${AZURE_STORAGE_ACCOUNT}" ]]; then
  echo "AZURE_STORAGE_ACCOUNT is required"
  exit 1
fi

if [[ -z "${AZURE_STORAGE_KEY}" ]]; then
  echo "AZURE_STORAGE_KEY is required"
  exit 1
fi

if [[ -z "${AZURE_STORAGE_CONNECTION_STRING}" ]]; then
  echo "AZURE_STORAGE_CONNECTION_STRING is required"
  exit 1
fi

# Evaluate git-sha value
GIT_SHA=$(git rev-parse --verify HEAD | tr -d '\n')

# Evaluate DeviceAgent version (from Info.plist)
VERSION=$(plutil -p ./Products/app/DeviceAgent/DeviceAgent-Runner.app/Info.plist | grep CFBundleShortVersionString | grep -o '"[[:digit:].]*"' | sed 's/"//g')

# Evaluate the Xcode version used to build artifacts
XC_VERSION=$(xcode_version)

az --version

WORKING_DIR="${BUILD_SOURCESDIRECTORY}"

# Upload `DeviceAgent.ipa`
IPA="${WORKING_DIR}/Products/ipa/DeviceAgent/DeviceAgent-Runner.ipa"
IPA_NAME="DeviceAgent-${VERSION}-Xcode-${XC_VERSION}-${GIT_SHA}.ipa"
azupload "${IPA}" "${IPA_NAME}"

# Upload `DeviceAgent.app`
APP="${WORKING_DIR}/Products/app/DeviceAgent/DeviceAgent-Runner.app"
APP_NAME="DeviceAgent-${VERSION}-Xcode-${XC_VERSION}-${GIT_SHA}.app"
azupload "${APP}" "${APP_NAME}"

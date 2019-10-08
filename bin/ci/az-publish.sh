#!/usr/bin/env bash

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

if [ -e ./.azure-credentials ]; then
  source ./.azure-credentials
fi

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

if [ "${BUILD_SOURCESDIRECTORY}" != "" ]; then
  WORKING_DIR="${BUILD_SOURCESDIRECTORY}"
else
  WORKING_DIR="."
fi

PRODUCT_DIR="${WORKING_DIR}/Products/ipa/DeviceAgent"
INFO_PLIST="${PRODUCT_DIR}/DeviceAgent-Runner.app/Info.plist"

VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" ${INFO_PLIST})

XC_VERSION=$(/usr/libexec/PlistBuddy -c "Print :DTXcode" ${INFO_PLIST})
XC_BUILD=$(/usr/libexec/PlistBuddy -c "Print :DTXcodeBuild" ${INFO_PLIST})

# Xcode 10.3 reports as 1030, which is confusing
if [[ "${XC_VERSION}" = "1020"  &&  "${XC_BUILD}" = "10G1d" ]]; then
  XC_VERSION="1030"
fi

GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ "${GIT_BRANCH}" =~ "tag/" ]]; then
  BUILD_ID="DeviceAgent-${VERSION}-Xcode-${XC_VERSION}-${GIT_SHA}"
else
  BUILD_ID="DeviceAgent-${VERSION}-Xcode-${XC_VERSION}-${GIT_SHA}-AdHoc"
fi

IPA="${PRODUCT_DIR}/DeviceAgent-Runner.ipa"
azupload "${IPA}" "${BUILD_ID}.ipa"

APP="${WORKING_DIR}/Products/app/DeviceAgent-Runner.app.zip"
azupload "${APP}" "${BUILD_ID}.app.zip"

echo "${BUILD_ID}"

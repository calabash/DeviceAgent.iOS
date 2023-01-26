#!/usr/bin/env bash

source "bin/log.sh"
source "bin/xcode.sh"

if [ -z ${1} ]; then
  echo "Usage: ${0} device-set"
  exit 1
fi

CREDS=.xtc-credentials
if [ ! -e "${CREDS}" ]; then
  error "This script requires a ${CREDS} file"
  error "Generating a template now:"
  cat >${CREDS} <<EOF
export XTC_PRODUCTION_API_TOKEN=
export XTC_STAGING_API_TOKEN=
export XTC_USER=
EOF
  cat ${CREDS}
  error "Update the file with your credentials and run again."
  error "Bye."
  exit 1
fi

source "${CREDS}"

if [ "${XTC_UPLOADER}" != "" ]; then
  info "Using ${XTC_UPLOADER}"
elif [ -e bin/test-cloud-uploader/xtc/xtc ]; then
  info "Found bin/test-cloud-uploader/xtc/xtc; will use it for uploading"
  XTC_UPLOADER=bin/test-cloud-uploader/xtc/xtc
else
  XTC_UPLOADER=bin/test-cloud-uploader/xtc/xtc
  info "Downloading the latest xtc binary"
  rm -rf bin/test-cloud-uploader
  mkdir -p bin/test-cloud-uploader
  curl -o bin/test-cloud-uploader/xtc.tar.gz \
    http://calabash-ci.xyz:8080/job/Uploader%20master/lastSuccessfulBuild/artifact/publish/Release/xtc.osx.10.10-x64.tar.gz
  $(cd bin/test-cloud-uploader; tar -xzf xtc.tar.gz)
  rm -rf bin/test-cloud-uploader/xtc.tar.gz
  info "Installed bin/test-cloud-uploader/xtc"
fi

WORKSPACE="Products/ipa/TestApp/$(xcode_version)/UITests"

set -e

if [ ! -e "${WORKSPACE}" ]; then
  bin/xcuitest/build-for-testing.sh arm
else
  info "Using existing workspace: ${WORKSPACE}"
fi

if [ -z $XTC_ENDPOINT ]; then
  info "Uploading to Production"
  API_TOKEN="${XTC_PRODUCTION_API_TOKEN}"
  XTC_USER="${XTC_PRODUCTION_USER}"
  ENDPOINT="${XTC_PRODUCTION_ENDPOINT}"
else
  API_TOKEN="${XTC_STAGING_API_TOKEN}"
  XTC_USER="${XTC_STAGING_USER}"
  ENDPOINT="${XTC_STAGING_ENDPOINT}"
  info "Uploading to Staging"
fi

if [ "${SERIES}" = "" ]; then
  SERIES=master
fi

PIPELINE="pipeline:<branch>"
BIN_ROOT="../files"
LIB_BEETS="${BIN_ROOT}/libBetaVulgaris.dylib"
LIB_CABBAGE="${BIN_ROOT}/libBrassica.dylib"
LIB_CUCUMBER="${BIN_ROOT}/libCucurbits.dylib"
INJECT="inject:${LIB_BEETS};${LIB_CABBAGE};${LIB_CUCUMBER}"
PARAMETERS="${INJECT}"

XTC_ENDPOINT=${ENDPOINT} \
 "${XTC_UPLOADER}" xcuitest \
  "${API_TOKEN}" \
  --devices "${1}" \
  --app-name "TestApp" \
  --series "${SERIES}" \
  --user "${XTC_USER}" \
  --workspace "${WORKSPACE}" \
  --test-parameters "${PARAMETERS}"

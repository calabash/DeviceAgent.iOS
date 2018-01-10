#!/usr/bin/env bash

source "bin/log.sh"
source "bin/xcode.sh"

set +e
hash appcenter 2>/dev/null
if [ $? -eq 0 ]; then
  info "Using $(appcenter --version)"
else
  error "appcenter cli is not installed."
  error ""
  error "$ brew update; brew install npm"
  error "$ npm install -g appcenter-cli"
  error ""
  error "Then try again."
  exit 1
fi
set -e

CAL_CODESIGN="${HOME}/.calabash/calabash-codesign"
if [ -e "${CAL_CODESIGN}" ]; then
  AC_TOKEN=$("${CAL_CODESIGN}/apple/find-appcenter-credential.sh" api-token)
else
  if [ "${AC_TOKEN}" = "" ]; then
    error "Expected calabash-codesign to be installed to:"
    error "  ${CAL_CODESIGN}"
    error "or AC_TOKEN environment variable to be defined."
    error ""
    error "Need an AppCenter API Token to proceed"
    exit 1
  fi
fi

info "Will use token: ${AC_TOKEN}"

# Requires S3 credentials
#IPA=Products/ipa/DeviceAgent/DeviceAgent-Runner.ipa
#SHA=$(/usr/bin/shasum "${IPA}" | awk '{print $1}')
#info "Will use DeviceAgent.iOS: ${SHA}"
#
#URL="s3://calabash-files/ios-device-agent/${SHA}/DeviceAgent-Runner.ipa"
#EXISTS=$(aws s3 ls "${URL}")
#if [ "${EXISTS}" = "" ]; then
#  aws s3 cp "${IPA}" "${URL}"
#else
#  info "DeviceAgent-Runner.ipa already exists on S3 at"
#  info "  ${URL}"
#fi

rm -rf testcloud-submit/.xtc
mkdir -p testcloud-submit/.xtc

#echo "${SHA}" > testcloud-submit/.xtc/device-agent-sha

S3_ROOT="https://s3-eu-west-1.amazonaws.com/calabash-files/dylibs/to-test-injection"
LIB_BEETS="${S3_ROOT}/libBetaVulgaris.dylib"
LIB_CABBAGE="${S3_ROOT}/libBrassica.dylib"
LIB_CUCUMBER="${S3_ROOT}/libCucurbits.dylib"
INJECT="inject=${LIB_BEETS};${LIB_CABBAGE};${LIB_CUCUMBER}"

APP_ENV="app_env=ARG_FROM_UPLOADER_FOR_AUT=From-the-CLI-uploader!"

appcenter test run calabash \
  --project-dir testcloud-submit \
  --app "App-Center-Test-Cloud/DeviceAgent-TestApp" \
  --devices "App-Center-Test-Cloud/deviceagent-testapp" \
  --app-path "testcloud-submit/TestApp.ipa" \
  --test-series "develop" \
  --config-path "cucumber.yml" \
  --token "${AC_TOKEN}" \
  --disable-telemetry \
  --test-parameter ${INJECT} \
  --test-parameter ${APP_ENV} \
  --async \
  --include .xtc

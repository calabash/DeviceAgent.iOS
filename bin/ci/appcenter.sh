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

KEYCHAIN="${HOME}/.test-cloud-dev/TestCloudDev.keychain"

if [ ! -e "${KEYCHAIN}" ]; then
  echo "Cannot find S3 credentials: there is no TestCloudDev.keychain"
  echo "  ${KEYCHAIN}"
  exit 1
fi

if [ ! -e "${HOME}/.test-cloud-dev/find-keychain-credential.sh" ]; then
  echo "Cannot find S3 credentials: no find-keychain-credential.sh script"
  echo "  ${HOME}/.test-cloud-dev/find-keychain-credential.sh"
  exit 1
fi

export AWS_ACCESS_KEY_ID=$(
"${HOME}/.test-cloud-dev/find-keychain-credential.sh" s3-access-key
)
export AWS_SECRET_ACCESS_KEY=$(
"${HOME}/.test-cloud-dev/find-keychain-credential.sh" s3-secret
)

if [ "${AC_TOKEN}" = "" ]; then
  AC_TOKEN=$("${HOME}/.test-cloud-dev/find-keychain-credential.sh" api-token)
fi

IPA=Products/ipa/DeviceAgent/DeviceAgent-Runner.ipa
SHA=$(/usr/bin/shasum "${IPA}" | awk '{print $1}')
info "Will use DeviceAgent.iOS: ${SHA}"

# Push will succeed even if file already exists
URL="s3://calabash-files/ios-device-agent/${SHA}/DeviceAgent-Runner.ipa"
aws s3 cp "${IPA}" "${URL}"

rm -rf testcloud-submit/.xtc
mkdir -p testcloud-submit/.xtc

echo "${SHA}" > testcloud-submit/.xtc/device-agent-sha

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

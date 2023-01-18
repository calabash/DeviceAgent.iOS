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

IPA=Products/ipa/DeviceAgent/DeviceAgent-Runner.ipa
SHA=$(/usr/bin/shasum "${IPA}" | awk '{print $1}')
info "Will use DeviceAgent.iOS: ${SHA}"

# Push will succeed even if file already exists
az storage blob upload \
    --account-name xtcruntimeartifacts \
    --container-name ios-device-agent/${SHA} \
    --name DeviceAgent-Runner.ipa \
    --file ${IPA} \

rm -rf testcloud-submit/.xtc
mkdir -p testcloud-submit/.xtc

echo "${SHA}" > testcloud-submit/.xtc/device-agent-sha

AZURE_ROOT="../files"
LIB_BEETS="${AZURE_ROOT}/libBetaVulgaris.dylib"
LIB_CABBAGE="${AZURE_ROOT}/libBrassica.dylib"
LIB_CUCUMBER="${AZURE_ROOT}/libCucurbits.dylib"
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

#!/usr/bin/env bash

set -e

if [ -z ${1} ]; then
  echo "Usage: ${0} device-set [DeviceAgent-SHA]

Examples:

$ bin/xtc.sh e9232255
$ SKIP_IPA_BUILD=1 SERIES='Args and env' bin/xtc.sh e9232255
$ SERIES='DeviceAgent 2.0' bin/xtc.sh e9232255 48d137d6228ccda303b2a71b0d09e1d0629bf980

The DeviceAgent-SHA optional argument allows tests to be run against any
DeviceAgent that has been uploaded to S3 rather than the current active
DeviceAgent for Test Cloud.

Responds to these env variables:

        SERIES: the Test Cloud series
SKIP_IPA_BUILD: iff 1, then skip re-building the ipa.
                'make test-ipa' will still be called, so changes in the
                features/ directory will be staged and sent to Test Cloud.
"

  exit 64
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

# TODO control with arguments or env variables
#
# The uninstall/install dance is required to test changes in
# run-loop and calabash-cucumber in Test Cloud
#gem uninstall -Vax --force --no-abort-on-dependent run_loop
#(cd ../run_loop; rake install)

#gem uninstall -Vax --force --no-abort-on-dependent calabash-cucumber
#(cd ../calabash-ios/calabash-cucumber; rake install)

PREPARE_XTC_ONLY="${SKIP_IPA_BUILD}" make test-ipa

cd xtc-submit

rm -rf .xtc
mkdir -p .xtc

if [ "${2}" != "" ]; then
  echo "${2}" > .xtc/device-agent-sha

if [ "${SERIES}" = "" ]; then
  SERIES=master
fi

if [ -z $XTC_ENDPOINT ]; then
  API_TOKEN="${XTC_PRODUCTION_API_TOKEN}"
  ENDPOINT="${XTC_PRODUCTION_ENDPOINT}"
  info "Uploading to Production"
else
  API_TOKEN="${XTC_STAGING_API_TOKEN}"
  ENDPOINT="${XTC_STAGING_ENDPOINT}"
  info "Uploading to Staging"
fi


# To submit to a pipeline branch, replace <branch> and append to
# PARAMETERS
PIPELINE="pipeline:<branch>"

# Required for Test Cloud Scenarios to pass; parameters always
# needs to include these!
APP_ENV="app_env:ARG_FROM_UPLOADER_FOR_AUT=From-the-CLI-uploader!"
PARAMETERS="${APP_ENV}"

XTC_ENDPOINT="${ENDPOINT}" \
bundle exec test-cloud submit \
  TestApp.ipa \
  $API_TOKEN \
  --user $XTC_USER \
  --app-name "TestApp" \
  --devices "${1}" \
  --series "${SERIES}" \
  --config cucumber.yml \
  --profile default \
  --dsym-file "TestApp.app.dSYM" \
  --include .xtc \
  --test-parameters ${PARAMETERS}

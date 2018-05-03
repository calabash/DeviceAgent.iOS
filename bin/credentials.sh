#!/usr/bin/env bash

set +e
hash appcenter 2>/dev/null
if [ $? -eq 0 ]; then
  info "Using $(appcenter --version)"
  set -e
else
  error "appcenter cli is not installed."
  error ""
  error "$ brew update; brew install npm"
  error "$ npm install -g appcenter-cli"
  error ""
  error "Then try again."
  exit 1
fi


CAL_CODESIGN="${HOME}/.calabash/calabash-codesign"
if [ -e "${CAL_CODESIGN}" ]; then
  AC_TOKEN=$("${CAL_CODESIGN}/apple/find-appcenter-credential.sh" api-token)
else
  error "Expected calabash-codesign to be installed to:"
  error "  ${CAL_CODESIGN}"
  error "or AC_TOKEN environment variable to be defined."
  error ""
  error "Need an AppCenter API Token to proceed"
  exit 1
fi

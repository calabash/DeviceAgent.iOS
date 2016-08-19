#!/usr/bin/env bash

function info {
  echo "$(tput setaf 2)INFO: $1$(tput sgr0)"
}

function warn {
  echo "$(tput setaf 3)WARN: $1$(tput sgr0)"
}

function error {
  echo "$(tput setaf 1)ERROR: $1$(tput sgr0)"
}

# $1 => error code
function fail_in_ci {
  if [ -z "${TRAVIS}" ] && [ -z "${JENKINS_HOME}" ]; then
    echo
    warn "Failed to make docs without errors"
    warn "In CI environments this would fail the build"
    exit 0
  else
    echo
    error "Failed to make docs without errors in a CI enviroment"
    error "Did you forget to document something?"
    error "Exiting $1"
    exit $1
  fi
}

DOCS_DIR="./documentation"

appledoc \
--project-name "DeviceAgent" \
--project-company "Xamarin" \
--company-id "sh.calaba" \
--templates "${PWD}/.appledoc" \
--install-docset \
--output "${DOCS_DIR}" \
--keep-undocumented-objects \
--keep-intermediate-files YES\
--search-undocumented-doc \
--no-repeat-first-par \
--ignore "*.m" \
--ignore "Server/NSXPCConnection.h" \
./Server

EC=$?

if [ "$EC" = 0 ]; then
  info "Docs published to ${DOCS_DIR}"
  info "Docs installed to Xcode"
  exit $EC
elif [ "$EC" = 1 ]; then #I am hoping that other failures will have different exit codes...
  echo ""
  info "Docs published to ${DOCS_DIR}"
  info "Docs installed to Xcode"
  echo ""
  warn "Some headers are missing documentation."
  warn "Please be diligent in documenting new headers!"
  warn "See http://www.cocoanetics.com/2011/11/amazing-apple-like-documentation/"

  fail_in_ci $EC
else
  error "Failed to create documentation"
  exit $EC
fi


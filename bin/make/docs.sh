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

DOCS_DIR="./documentation"

appledoc \
--project-name "CBXDriver" \
--project-company "Xamarin" \
--company-id "sh.calaba" \
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
elif [ "$EC" = 1 ]; then #I am hoping that other failures will have different exit codes...
  echo ""
  info "Docs published to ${DOCS_DIR}"
  echo ""
  warn "Some headers are missing documentation."
  warn "Please be diligent in documenting new headers!"
  warn "See http://www.cocoanetics.com/2011/11/amazing-apple-like-documentation/"
else
  error "Failed to create documentation"
fi

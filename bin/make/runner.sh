#!/usr/bin/env bash

function info {
  echo "$(tput setaf 2)INFO: $1$(tput sgr0)"
}

function error {
  echo "$(tput setaf 1)ERROR: $1$(tput sgr0)"
}


bin/make/ipa.sh

if [ "$?" -ne 0 ]; then
  error "Unable to build ipa..."
  exit 1
fi

info "Checking for calabash-tool..."
calabash-tool 1>/dev/null

if [ "$?" -ne 0 ]; then
  error "Must have calabash-tool installed"
  exit 2
fi

cp TestManagerDConnection/CBX-BEEFBABE-FEED-BABE-BEEF-CAFEBEEFFACE.xctestconfiguration \
   Products/ipa/CBX-Runner.app/PlugIns/CBX.xctest/

if [ "$?" -ne 0 ]; then
  error "Something went wrong copying test configuration file..."
  exit 3
fi

cd Products/ipa 
mkdir Payload
cp -r CBX-Runner.app Payload 
zip -qr r.ipa Payload


info "Trying to resign..."
if [ -e runner.ipa ]; then
  error "runner.ipa exists! Delete it first and try again."
  exit 5
fi

calabash-tool resign r.ipa -o runner.ipa

if [ "$?" -ne 0 ]; then 
  error "Unable to resign."
  rm r.ipa
  exit 4
fi

rm r.ipa

info "All done! Created Products/ipa/runner.ipa"

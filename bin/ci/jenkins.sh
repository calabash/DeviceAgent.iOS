#!/usr/bin/env bash

source bin/simctl.sh
source bin/xcode.sh
source bin/log.sh

export DEVELOPER_DIR="/Xcode/9.2/Xcode.app/Contents/Developer"

ensure_valid_core_sim_service

set -e

bundle install
make docs
bin/ci/install-keychain.sh
make app-agent
make unit-tests
make ipa-agent
make test-ipa

# TestApp is required for Cucumber tests.
make test-app
bundle exec bin/ci/cucumber.rb

#!/usr/bin/env bash


export DEVELOPER_DIR=/Xcode/8.1/Xcode.app/Contents/Developer

xcrun simctl help >/dev/null 2>&1
xcrun simctl help >/dev/null 2>&1
xcrun simctl help >/dev/null 2>&1

set -e

bundle install
make docs
make app-agent
make unit-tests
make ipa-agent
# TODO failing in CI because of Code Signing
#make test-ipa

# app-unit is required for cucumber tests.
make test-app
bundle exec bin/ci/cucumber.rb


#!/usr/bin/env bash

set -e

bundle install
make docs
make app-agent
make unit-tests
bin/ci/make-ipa-agent.sh
bin/ci/make-test-ipa.sh

# app-unit is required for cucumber tests.
make test-app
bundle exec bin/ci/cucumber.rb


#!/usr/bin/env bash

set -e

bundle install
make docs
make app-agent
make unit
bin/ci/make-ipa-agent.sh
bin/ci/make-ipa-unit.sh

# app-unit is required for cucumber tests.
make app-unit
bundle exec bin/ci/cucumber.rb


#!/usr/bin/env bash

bundle install
make app-agent
make unit
bin/ci/make-ipa-agent.sh
bin/ci/make-ipa-unit.sh

# app-unit is required for cucumber tests.
make app-unit
bundle exec bin/ci/cucumber.rb


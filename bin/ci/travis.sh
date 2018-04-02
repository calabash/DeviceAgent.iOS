#!/usr/bin/env bash

set -e

bundle install
make app-agent
make unit-tests
bin/ci/make-ipa-agent.sh
bin/ci/make-test-ipa.sh

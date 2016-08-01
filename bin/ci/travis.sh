#!/usr/bin/env bash

set -e

bundle install
bin/make/docs.sh
make app-agent
make unit-tests
bin/ci/make-ipa-agent.sh
bin/ci/make-test-app.sh


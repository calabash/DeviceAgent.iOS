#!/usr/bin/env bash

set -e

bundle install
bin/make/docs.sh
make app-agent
make unit
bin/ci/make-ipa-agent.sh
bin/ci/make-ipa-unit.sh


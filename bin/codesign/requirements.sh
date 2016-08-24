#!/usr/bin/env bash

xcrun codesign --display --verbose=4 -r- "${1}"

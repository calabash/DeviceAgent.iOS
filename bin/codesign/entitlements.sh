#!/usr/bin/env bash

xcrun codesign -d --entitlements :- "${1}"

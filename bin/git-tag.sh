#!/usr/bin/env bash

set -e

TAG=$(/usr/libexec/PlistBuddy -c \
  "Print :CFBundleShortVersionString" AppStub/Info.plist)

git tag -a "${TAG}" -m"${TAG}"
git push origin "${TAG}"
git branch "tag/${TAG}" "${TAG}"

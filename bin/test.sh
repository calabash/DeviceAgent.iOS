#!/usr/bin/env bash

xcodebuild \
  -project CBXDriver.xcodeproj \
 -target XCUITestDriver \
 -sdk iphonesimulator9.2 \
  GCC_TREAT_WARNINGS_AS_ERRORS=YES \
 -arch x86_64


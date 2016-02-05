#!/usr/bin/env bash

xcodebuild \
  -project ./xcuitest-server/xcuitest-server.xcodeproj \
 -target xcuitest-serverUITests \
 -sdk iphonesimulator9.2 \
  GCC_TREAT_WARNINGS_AS_ERRORS=YES \
 -arch x86_64


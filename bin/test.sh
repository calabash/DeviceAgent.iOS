#!/usr/bin/env sh

xcodebuild -project ./xcuitest-server/xcuitest-server.xcodeproj \
 -target xcuitest-serverUITests -sdk iphonesimulator9.2 -arch x86_64

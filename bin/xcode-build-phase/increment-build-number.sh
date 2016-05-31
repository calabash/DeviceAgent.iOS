#!/usr/bin/env bash

set -e

HEADER="${PROJECT_DIR}/${INFOPLIST_PREFIX_HEADER}"
PLIST="${PROJECT_DIR}/${INFOPLIST_FILE}"
touch "${PLIST}"

VERSION=`/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" $PLIST | tr -d '\n'`

NEW_BUILD_NUMBER=`date +%s`

cat > "${HEADER}" <<EOF
/*
DO NOT MANUALLY CHANGE THE CONTENTS OF THIS FILE

The PRODUCT_BUILD_NUMBER is advanced for every
build of ${PRODUCT_NAME} using:

$ date +%s

The PRODUCT_VERSION is used to set the

CBX-Runner.app/PlugIns/CBX.xctest/Info.plist

version from the CBXAppStub version. It is ignored
in other targets.

This file should not be added to version control.
*/

#define PRODUCT_BUILD_NUMBER ${NEW_BUILD_NUMBER}
#define PRODUCT_VERSION ${VERSION}
EOF


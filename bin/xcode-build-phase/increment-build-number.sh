#!/usr/bin/env bash

set -e

HEADER="${PROJECT_DIR}/${INFOPLIST_PREFIX_HEADER}"
PLIST="${PROJECT_DIR}/${INFOPLIST_FILE}"
touch "${PLIST}"

NEW_BUILD_NUMBER=`date +%s`

cat > "${HEADER}" <<EOF
/*
DO NOT MANUALLY CHANGE THE CONTENTS OF THIS FILE

The PRODUCT_BUILD_NUMBER is advanced for every
build of ${PRODUCT_NAME} using:

$ date +%s

This file should not be added to version control.
*/

#define PRODUCT_BUILD_NUMBER ${NEW_BUILD_NUMBER}
EOF


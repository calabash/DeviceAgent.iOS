#!/usr/bin/env bash

#NOT USED ANYMORE SINCE XCODE 14

source "bin/log.sh"
source "bin/ditto.sh"

SOURCE="${PLATFORM_DIR}/Developer/Library/PrivateFrameworks/XCTAutomationSupport.framework"
TARGET="${TARGET_BUILD_DIR}/${FULL_PRODUCT_NAME}/Frameworks/XCTAutomationSupport.framework"

ditto_or_exit "${SOURCE}" "${TARGET}"

xcrun codesign --sign "${EXPANDED_CODE_SIGN_IDENTITY_NAME}" --force --deep "${TARGET}"

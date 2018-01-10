#!/usr/bin/env bash

if [ "${1}" == "" ]; then
  echo ""
  echo "Run arbitrary XCUITests against any .app"
  echo ""
  echo "Usage:"
  echo ""
  echo "$0 path/to/AUT.app [simulator or device UDID]"
  echo ""
  echo "* .ipa archives must be expanded."
  echo "* If no UDID is provided, a default will be used."
  echo "* Tests targeting a physical device require the .app"
  echo "  is signed for the device.  The app will be installed"
  echo "  on the device as part of the xcodebuild command."
  exit 0
fi

source bin/log.sh
source bin/ditto.sh
source bin/simctl.sh
source bin/instruments.sh

ensure_valid_core_sim_service

banner "Preparing"

APP="${1}"

if [ ! -d "${APP}" ] || [ "${APP: -4}" != ".app" ]; then
  error "Expected .app bundle to exist at path:"
  error "  ${1}"
  exit 1
fi

INFOPLIST="${APP}/Info.plist"

if [ ! -e "${INFOPLIST}" ]; then
  error "Expected Info.plist to exist at path:"
  error "  ${INFOPLIST}"
  exit 1
fi

EXEC_NAME=$(/usr/libexec/PlistBuddy -c "Print :CFBundleExecutable" "${INFOPLIST}" | tr -d '\n')
EXEC_PATH="${APP}/${EXEC_NAME}"

if [ "${EXEC_NAME}" = "" ]; then
  error "Expected Info.plist to contain key CFBundleExecutable"
  error "  ${INFOPLIST}"
  exit 1
fi

if [ ! -e "${EXEC_PATH}" ]; then
  error "Expected .app bundle to contain executable file:"
  error "  ${EXEC_PATH}"
  exit 1
fi

AUT_APP_BUNDLE=$(basename "${APP}" | tr -d '\n')

LIPO_ARCHES=$(
xcrun lipo -info "${EXEC_PATH}" | \
  cut -d":" -f3 | awk '{$1=$1};1'
)

XC_SCHEME="StandAloneUITests"
XC_TARGET="StandAloneUITests"
XC_WORKSPACE="DeviceAgent.xcworkspace"
XC_CONFIG=Debug

if [[ "${LIPO_ARCHES}" =~ "arm" ]]; then
  ARCHS="armv7 armv7s arm64"
  XC_BUILD_DIR="build/standalone-xcuitest/arm"
  INSTALL_DIR=Products/ipa/standalone-xcuitest
  BUILD_PRODUCTS_DIR="${XC_BUILD_DIR}/Build/Products/${XC_CONFIG}-iphoneos"
  SDK="iphoneos"
  info "AUT was built for arm devices"
else
  ARCHS="i386 x86_64"
  XC_BUILD_DIR="build/standalone-xcuitest/x86"
  INSTALL_DIR=Products/app/standalone-xcuitest
  BUILD_PRODUCTS_DIR="${XC_BUILD_DIR}/Build/Products/${XC_CONFIG}-iphonesimulator"
  SDK="iphonesimulator"
  info "AUT was built for x86 simulators"
fi

UDID="${2}"
if [ "${SDK}" = "iphoneos" ]; then
  if [ "${2}" = "" ]; then
    UDID=$(default_device_udid)
  fi

  if [ "${UDID}" = "" ]; then
    error "Could not find any iOS devices connected via USB"
    error "Does the device appear in the Xcode Devices window without errors?"
    exit 1
  fi
else
  if [ "${2}" = "" ]; then
    UDID=$(default_sim_udid)
  fi
fi

info "Will run tests on device $UDID"

hash xcpretty 2>/dev/null
if [ $? -eq 0 ] && [ "${XCPRETTY}" != "0" ]; then
  XC_PIPE='xcpretty -c'
else
  XC_PIPE='cat'
fi

info "Will pipe xcodebuild to: ${XC_PIPE}"

set -e -o pipefail

mkdir -p "${XC_BUILD_DIR}"

rm -rf "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}"

RUNNER=StandAloneUITests-Runner.app
INSTALLED_RUNNER="${INSTALL_DIR}/${RUNNER}"
INSTALLED_AUT="${INSTALL_DIR}/${AUT_APP_BUNDLE}"

info "Prepared install directory ${INSTALL_DIR}"

BUILD_PRODUCTS_RUNNER="${BUILD_PRODUCTS_DIR}/${RUNNER}"

mkdir -p "${BUILD_PRODUCTS_DIR}"

info "Prepared build directory ${XC_BUILD_DIR}"

banner "Building ${RUNNER}"

COMMAND_LINE_BUILD=1 \
  xcrun xcodebuild  \
  -SYMROOT="${XC_BUILD_DIR}" \
  -OBJROOT="${XC_BUILD_DIR}" \
  -derivedDataPath "${XC_BUILD_DIR}" \
  -scheme "${XC_SCHEME}" \
  -workspace "${XC_WORKSPACE}" \
  -configuration "${XC_CONFIG}" \
  -sdk "${SDK}" \
  ARCHS="${ARCHS}" \
  VALID_ARCHS="${ARCHS}" \
  ONLY_ACTIVE_ARCH=NO \
  build-for-testing | $XC_PIPE

info "Building app succeeded."

banner "Installing Artifacts"

install_with_ditto "${BUILD_PRODUCTS_RUNNER}" "${INSTALLED_RUNNER}"
install_with_ditto "${APP}" "${INSTALLED_AUT}"

info "Installing resolved.xctestrun"

TEMPLATE=StandAloneUITests/template.xctestrun
XCTESTRUN="${INSTALL_DIR}/resolved.xctestrun"

sed -e \
  's@__RUNNER__@'"${RUNNER}"'@g;s@__AUT_APP__@'"${AUT_APP_BUNDLE}"'@g' \
  "${TEMPLATE}" > "${XCTESTRUN}"

cat $XCTESTRUN

#-xctestrun MyTestRun.xctestrun -destination
#'platform=iOS Simulator,name=iPhone 5s'
#
#  -SYMROOT="${XC_BUILD_DIR}" \
#  -OBJROOT="${XC_BUILD_DIR}" \
#  -derivedDataPath "${XC_BUILD_DIR}" \
COMMAND_LINE_BUILD=1 \
  xcrun xcodebuild  \
  -xctestrun "${XCTESTRUN}" \
  -sdk "${SDK}" \
  -destination "id=$UDID" \
  test-without-building | $XC_PIPE

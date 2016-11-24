#!/usr/bin/env bash

set -e
CUCUMBER_ARGS="--format progress --tags @keyboard"

TEST_SIM=1
TEST_DEVICE=1

if [ "${1}" = "device" ]; then
  TEST_SIM=0
  TEST_DEVICE=1
elif [ "${1}" = "sim" ]; then
  TEST_SIM=1
  TEST_DEVICE=0
else
  echo "Error: unknown argument: ${1}"
  exit 1
fi

export CODE_SIGN_IDENTITY="iPhone Developer: Karl Krukow (YTTN6Y2QS9)"

# Quit the TestApp at_exit to ensure the next test launches the app
# in the correct state. See features/support/01_launch.rb
export QUIT_AUT_AFTER_CUCUMBER="1"

# If a Scenario fails, exit the cucumber process and fail this script.
# See features/support/01_launch.rb
export ON_SCENARIO_FAILURE="exit"

function banner {
  if [ "${TERM}" = "dumb" ]; then
    echo ""
    echo "######## $1 ########"
    echo ""
  else
    echo ""
    echo "$(tput setaf 5)######## $1 ########$(tput sgr0)"
    echo ""
  fi
}

function info {
  if [ "${TERM}" = "dumb" ]; then
    echo "INFO: $1"
  else
    echo "$(tput setaf 2)INFO: $1$(tput sgr0)"
  fi
}

# Xcode 8.0
export DEVELOPER_DIR=/Xcode/8.0/Xcode.app/Contents/Developer

banner "Xcode 8.0"
xcrun xcodebuild -version

if [ $TEST_SIM -eq 1 ]; then
  info "Default Simulator"
  bundle exec cucumber ${CUCUMBER_ARGS}

  info "iOS 9.3 Simulator"
  DEVICE_TARGET=BD2010F9-401C-4E56-AE8A-ECB7CD3370D8 \
    bundle exec cucumber ${CUCUMBER_ARGS}

  info "iOS 9.3 Simulator iPhone 5c"
  DEVICE_TARGET=D1B22B9C-F105-4DF0-8FA3-7AE41E212A9D \
    bundle exec cucumber ${CUCUMBER_ARGS}

  info "iOS 10.0 Simulator iPhone 5c"
  DEVICE_TARGET=FEBB7F64-516F-46B5-9CD8-BC361A297A34 \
    bundle exec cucumber ${CUCUMBER_ARGS}
fi

if [ $TEST_DEVICE -eq 1 ]; then
  declare -a devices=("mercury" "wolf" "uranus")

  for device in "${devices[@]}"
  do
    info "Device: $device"

    DEVICE_TARGET=$device \
      APP=sh.calaba.TestApp \
      bundle exec cucumber ${CUCUMBER_ARGS}
  done
fi

# Xcode 8.1
export DEVELOPER_DIR=/Xcode/8.1/Xcode.app/Contents/Developer

banner "Xcode 8.1"
xcrun xcodebuild -version

if [ $TEST_SIM -eq 1 ]; then
  info "Default Simulator"
  bundle exec cucumber ${CUCUMBER_ARGS}

  info "iOS 10.0 Simulator"
  DEVICE_TARGET=B35DFE6A-3675-4154-912D-2C6864AD4AAF \
    bundle exec cucumber ${CUCUMBER_ARGS}

  info "iOS 9.3 Simlator"
  DEVICE_TARGET=F6EF1FA5-1C3F-465E-8B29-70C293DE0F66 \
    bundle exec cucumber ${CUCUMBER_ARGS}

  info "iOS 9.3 Simulator iPhone 5c"
  DEVICE_TARGET=D1B22B9C-F105-4DF0-8FA3-7AE41E212A9D \
    bundle exec cucumber ${CUCUMBER_ARGS}

  info "iOS 10.0 Simulator iPhone 5c"
  DEVICE_TARGET=FEBB7F64-516F-46B5-9CD8-BC361A297A34 \
    bundle exec cucumber ${CUCUMBER_ARGS}

  info "iOS 10.1 Simulator iPhone 5c"
  DEVICE_TARGET=E0D0814E-E655-482C-A10A-3019E3A0BCE7 \
    bundle exec cucumber ${CUCUMBER_ARGS}
fi

if [ $TEST_DEVICE -eq 1 ]; then
  declare -a devices=("mercury" "wolf" "uranus" "pegasi" "denis")

  for device in "${devices[@]}"
  do
    info "Device: $device"
    DEVICE_TARGET=$device \
      APP=sh.calaba.TestApp \
      bundle exec cucumber ${CUCUMBER_ARGS}
  done
fi

# Xcode 8.2 beta 2
export DEVELOPER_DIR=/Xcode/8.2/Xcode-beta.app/Contents/Developer

banner "Xcode 8.2"
xcrun xcodebuild -version

info "Default Simulator"
bundle exec cucumber ${CUCUMBER_ARGS}

if [ $TEST_SIM -eq 1 ]; then
  info "iOS 10.1 Simulator"
  DEVICE_TARGET=8B9B8DE5-79DA-4C2E-B430-0FD0FC4FE58D \
    bundle exec cucumber ${CUCUMBER_ARGS}

  info "iOS 10.0 Simlator"
  DEVICE_TARGET=B35DFE6A-3675-4154-912D-2C6864AD4AAF \
    bundle exec cucumber ${CUCUMBER_ARGS}

  info "iOS 9.3 Simulator"
  DEVICE_TARGET=F6EF1FA5-1C3F-465E-8B29-70C293DE0F66 \
    bundle exec cucumber ${CUCUMBER_ARGS}

  info "iOS 9.3 Simulator iPhone 5c"
  DEVICE_TARGET=D1B22B9C-F105-4DF0-8FA3-7AE41E212A9D \
    bundle exec cucumber ${CUCUMBER_ARGS}

  info "iOS 10.0 Simulator iPhone 5c"
  DEVICE_TARGET=FEBB7F64-516F-46B5-9CD8-BC361A297A34 \
    bundle exec cucumber ${CUCUMBER_ARGS}

  info "iOS 10.1 Simulator iPhone 5c"
  DEVICE_TARGET=E0D0814E-E655-482C-A10A-3019E3A0BCE7 \
    bundle exec cucumber ${CUCUMBER_ARGS}

  info "iOS 10.2 Simulator iPhone 5c"
  DEVICE_TARGET=8B4F2F90-FEAB-4014-8B20-419ED7D63DD5 \
    bundle exec cucumber ${CUCUMBER_ARGS}
fi

declare -a devices=("mercury" "wolf" "uranus" "pegasi" "denis" "hat")

if [ $TEST_DEVICE -eq 1 ]; then
  for device in "${devices[@]}"
  do
    info "Device: $device"
    DEVICE_TARGET=$device \
      APP=sh.calaba.TestApp \
      bundle exec cucumber ${CUCUMBER_ARGS}
  done
if


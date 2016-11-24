#!/usr/bin/env bash

set -e
CUCUMBER_ARGS="--format progress --tags @keyboard"

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

info "Default Simulator"
bundle exec cucumber ${CUCUMBER_ARGS}

info "iOS 9.3 Simulator"
DEVICE_TARGET=7D25AA5B-F939-4BC8-AD5D-6280E71DAE0B \
  bundle exec cucumber ${CUCUMBER_ARGS}

declare -a devices=("mercury" "wolf" "uranus")

for device in "${devices[@]}"
do
  info "Device: $device"

  DEVICE_TARGET=$device \
    APP=sh.calaba.TestApp \
    bundle exec cucumber ${CUCUMBER_ARGS}
done

# Xcode 8.1
export DEVELOPER_DIR=/Xcode/8.1/Xcode.app/Contents/Developer

banner "Xcode 8.1"
xcrun xcodebuild -version

info "Default Simulator"
bundle exec cucumber ${CUCUMBER_ARGS}

info "iOS 10.0 Simulator"
DEVICE_TARGET=B6D21623-32F6-44F5-90ED-7E520DC94A69 \
  bundle exec cucumber ${CUCUMBER_ARGS}

info "iOS 9.3 Simlator"
DEVICE_TARGET=6DD279B3-7FED-4902-96F4-618D55540ADC \
  bundle exec cucumber ${CUCUMBER_ARGS}

declare -a devices=("mercury" "wolf" "uranus" "pegasi" "denis")

for device in "${devices[@]}"
do
  info "Device: $device"
  DEVICE_TARGET=$device \
    APP=sh.calaba.TestApp \
    bundle exec cucumber ${CUCUMBER_ARGS}
done

# Xcode 8.2 beta 2
export DEVELOPER_DIR=/Xcode/8.2/Xcode-beta.app/Contents/Developer

banner "Xcode 8.2"
xcrun xcodebuild -version

info "Default Simulator"
bundle exec cucumber ${CUCUMBER_ARGS}

info "iOS 10.1 Simulator"
DEVICE_TARGET=E160BC4E-CAD5-4680-9C42-D510FB4BB052 \
  bundle exec cucumber ${CUCUMBER_ARGS}

info "iOS 10.0 Simlator"
DEVICE_TARGET=6DD279B3-7FED-4902-96F4-618D55540ADC \
  bundle exec cucumber ${CUCUMBER_ARGS}

info "iOS 9.3 Simulator"
DEVICE_TARGET=B6D21623-32F6-44F5-90ED-7E520DC94A69 \
  bundle exec cucumber ${CUCUMBER_ARGS}

declare -a devices=("mercury" "wolf" "uranus" "pegasi" "denis" "hat")

for device in "${devices[@]}"
do
  info "Device: $device"
  DEVICE_TARGET=$device \
    APP=sh.calaba.TestApp \
    bundle exec cucumber ${CUCUMBER_ARGS}
done


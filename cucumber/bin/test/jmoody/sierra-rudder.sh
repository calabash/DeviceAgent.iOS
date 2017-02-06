#!/usr/bin/env bash

set -e
CUCUMBER_ARGS="--format pretty --tags @meta"

if [ "${1}" = "device" ]; then
  TEST_SIM=0
  TEST_DEVICE=1
elif [ "${1}" = "sim" ]; then
  TEST_SIM=1
  TEST_DEVICE=0
elif [ "${1}" = "" ]; then
  TEST_SIM=1
  TEST_DEVICE=1
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

# Erase the simulator before starting the first test.
# See features/support/01_launch.rb
export ERASE_SIM_BEFORE="1"

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
  info "Xcode 8.0 Default Simulator"
  bundle exec cucumber ${CUCUMBER_ARGS}

  info "Xcode 8.0 iOS 9.3 iPad 2 Simulator"
  DEVICE_TARGET=655161BC-6746-4C9B-9E76-E45997E3B4B5 \
    bundle exec cucumber ${CUCUMBER_ARGS}

  info "Xcode 8.0 iOS 9.3 Simulator iPhone 5c"
  DEVICE_TARGET=0325DDEB-950D-43EB-8FC1-82728AD04815 \
    bundle exec cucumber ${CUCUMBER_ARGS}

  info "Xcode 8.0 iOS 10.0 Simulator iPhone 5c"
  DEVICE_TARGET=296E455E-DEDB-40D5-8E42-7A6AEBEDC13F \
    bundle exec cucumber ${CUCUMBER_ARGS}
fi

if [ $TEST_DEVICE -eq 1 ]; then
  declare -a devices=("mercury" "wolf" "uranus")

  for device in "${devices[@]}"
  do
    info "Xcode 8.0 with device: $device"

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
  info "Xcode 8.1 Default Simulator"
  bundle exec cucumber ${CUCUMBER_ARGS}

  info "Xcode 8.1 iOS 10.0 Simulator"
  DEVICE_TARGET=F4B699F0-B10A-4FBD-850A-AC416DAC4AA0 \
    bundle exec cucumber ${CUCUMBER_ARGS}

  info "Xcode 8.1 iOS 9.3 iPad 2 Simlator"
  DEVICE_TARGET=655161BC-6746-4C9B-9E76-E45997E3B4B5 \
    bundle exec cucumber ${CUCUMBER_ARGS}

  info "Xcode 8.1 iOS 9.3 Simulator iPhone 5c"
  DEVICE_TARGET=0325DDEB-950D-43EB-8FC1-82728AD04815 \
    bundle exec cucumber ${CUCUMBER_ARGS}

  info "Xcode 8.1 iOS 10.0 Simulator iPhone 5c"
  DEVICE_TARGET=296E455E-DEDB-40D5-8E42-7A6AEBEDC13F \
    bundle exec cucumber ${CUCUMBER_ARGS}

  info "Xcode 8.1 iOS 10.1 Simulator iPhone 5c"
  DEVICE_TARGET=0CFC523F-DA85-4BDF-B9EC-4C4A37045122 \
    bundle exec cucumber ${CUCUMBER_ARGS}
fi

if [ $TEST_DEVICE -eq 1 ]; then
  declare -a devices=("mercury" "wolf" "uranus" "pegasi" "denis")

  for device in "${devices[@]}"
  do
    info "Xcode 8.1 with device: $device"
    DEVICE_TARGET=$device \
      APP=sh.calaba.TestApp \
      bundle exec cucumber ${CUCUMBER_ARGS}
  done
fi

# Xcode 8.2.1
export DEVELOPER_DIR=/Xcode/8.2.1/Xcode.app/Contents/Developer

banner "Xcode 8.2.1"
xcrun xcodebuild -version

if [ $TEST_SIM -eq 1 ]; then
  info "Xcode 8.2.1 Default Simulator"
  bundle exec cucumber ${CUCUMBER_ARGS}

  info "Xcode 8.2.1 iOS 10.1 Simulator"
  DEVICE_TARGET=EB5DCF8D-F3DC-4A12-AD6D-E9B249194728 \
    bundle exec cucumber ${CUCUMBER_ARGS}

  info "Xcode 8.2.1 iOS 10.0 Simlator"
  DEVICE_TARGET=F4B699F0-B10A-4FBD-850A-AC416DAC4AA0 \
    bundle exec cucumber ${CUCUMBER_ARGS}

  info "Xcode 8.2.1 iOS 9.3 Simulator iPad 2"
  DEVICE_TARGET=655161BC-6746-4C9B-9E76-E45997E3B4B5 \
    bundle exec cucumber ${CUCUMBER_ARGS}

  info "Xcode 8.2.1 iOS 9.3 Simulator iPhone 5c"
  DEVICE_TARGET=0325DDEB-950D-43EB-8FC1-82728AD04815 \
    bundle exec cucumber ${CUCUMBER_ARGS}

  info "Xcode 8.2.1 iOS 10.0 Simulator iPhone 5c"
  DEVICE_TARGET=296E455E-DEDB-40D5-8E42-7A6AEBEDC13F \
    bundle exec cucumber ${CUCUMBER_ARGS}

  info "Xcode 8.2.1 iOS 10.1 Simulator iPhone 5c"
  DEVICE_TARGET=0CFC523F-DA85-4BDF-B9EC-4C4A37045122 \
    bundle exec cucumber ${CUCUMBER_ARGS}

  info "Xcode 8.2.1 iOS 10.2 Simulator iPhone 5c"
  DEVICE_TARGET=1A34A398-2B17-469D-87C1-554C68605C0D \
    bundle exec cucumber ${CUCUMBER_ARGS}
fi

if [ $TEST_DEVICE -eq 1 ]; then
  declare -a devices=("mercury" "wolf" "uranus" "pegasi" "denis")

  for device in "${devices[@]}"
  do
    info "Xcode 8.2.1 with device: $device"
    DEVICE_TARGET=$device \
      APP=sh.calaba.TestApp \
      bundle exec cucumber ${CUCUMBER_ARGS}
  done
fi


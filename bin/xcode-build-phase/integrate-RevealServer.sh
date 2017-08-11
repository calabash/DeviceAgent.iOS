#!/usr/bin/env bash

 export REVEAL_SERVER_FILENAME="RevealServer.framework"

 # Update this path to point to the location of RevealServer.framework in your project.
 export REVEAL_SERVER_PATH="${1}/Vendor/${REVEAL_SERVER_FILENAME}"

 # If configuration is not Debug, skip this script.
 [ "${2}" != "Debug" ] && exit 0

 # If RevealServer.framework exists at the specified path, run code signing script.
 if [ -d "${REVEAL_SERVER_PATH}" ]; then
   "${REVEAL_SERVER_PATH}/Scripts/copy_and_codesign_revealserver.sh"
 else
   echo "Reveal Server not loaded: RevealServer.framework could not be found."
 fi

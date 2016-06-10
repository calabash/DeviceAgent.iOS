#!/usr/bin/env bash
set -e
set -x

make app-agent
make ipa-agent

SIM_AGENT_HOME="${HOME}/.calabash/DeviceAgent/simulator"
DEV_AGENT_HOME="${HOME}/.calabash/DeviceAgent/device"  

rm -rf "${HOME}/.calabash/DeviceAgent"
mkdir -p "$SIM_AGENT_HOME"
mkdir -p "$DEV_AGENT_HOME"

mv "Products/app/DeviceAgent/CBX-Runner.app" "$SIM_AGENT_HOME"
mv "Products/ipa/DeviceAgent/CBX-Runner.app" "$DEV_AGENT_HOME"


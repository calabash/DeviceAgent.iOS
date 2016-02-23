#!/bin/sh

#  launch_runner.sh
#  XCUITestManagerDLink
#
#  Created by Chris Fuentes on 2/21/16.
#  Copyright © 2016 calabash. All rights reserved.

#Doesn't seem like it gets /usr/local/bin in the PATH
PATH=${PATH}:/usr/local/bin
#idevicelaunch com.xamarin.XCUITestRunner
idevicelaunch com.apple.test.CBX-Runner -e XCTestConfigurationFilePath Banana
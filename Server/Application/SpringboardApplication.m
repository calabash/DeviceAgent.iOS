/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "SpringboardApplication.h"
#import "Application+Queries.h"


@implementation SpringboardApplication

+ (instancetype)springboard
{
  static SpringboardApplication *_springboardApp;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _springboardApp = [[SpringboardApplication alloc] initPrivateWithPath:nil bundleID:@"com.apple.springboard"];
  });

  return _springboardApp;
}

@end

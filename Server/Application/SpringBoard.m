/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "SpringBoard.h"
#import "Application+Queries.h"

@implementation SpringBoard

+ (instancetype)application {
    static SpringBoard *_springBoard;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _springBoard = [[SpringBoard alloc]
                        initPrivateWithPath:nil
                        bundleID:@"com.apple.springboard"];
    });
    return _springBoard;
}

@end

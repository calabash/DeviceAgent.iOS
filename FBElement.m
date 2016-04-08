/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * 'Facebook-WebDriverAgent' file inside of the 'third-party-licenses' directory
 *  at the root of this project.
 */

#import "FBElement.h"

#import <Foundation/Foundation.h>

NSString *wdAttributeNameForAttributeName(NSString *name)
{
  return [NSString stringWithFormat:@"wd%@", name.capitalizedString];
}

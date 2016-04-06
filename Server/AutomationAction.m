//
//  AutomationAction.m
//  CBXDriver
//
//  Created by Chris Fuentes on 4/6/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "AutomationAction.h"
#import "CBException.h"
#import "CBMacros.h"

@implementation AutomationAction
+ (JSONActionValidator *)validator { _must_override_exception; }
@end

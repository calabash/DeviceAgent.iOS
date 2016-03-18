//
//  CBInvalidGestureException.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/18/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBInvalidGestureException.h"

@implementation CBInvalidGestureException
+ (instancetype)withMessage:(NSString *)message {
    return [self withMessage:message statusCode:HTTP_STATUS_CODE_EVERYTHING_OK];
}
@end

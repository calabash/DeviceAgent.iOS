//
//  CBShutdownServerException.m
//  xcuitest-server
//
//  Created by Chris Fuentes on 2/5/16.
//  Copyright © 2016 calabash. All rights reserved.
//

#import "CBShutdownServerException.h"

@implementation CBShutdownServerException
+ (instancetype)withMessage:(NSString *)message {
    return [self withMessage:message statusCode:HTTP_STATUS_CODE_EVERYTHING_OK];
}
@end

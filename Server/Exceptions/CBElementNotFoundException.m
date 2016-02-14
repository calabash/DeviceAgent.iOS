//
//  CBElementNotFoundException.m
//  xcuitest-server
//
//  Created by Chris Fuentes on 2/10/16.
//  Copyright © 2016 calabash. All rights reserved.
//

#import "CBElementNotFoundException.h"

@implementation CBElementNotFoundException
+ (instancetype)withMessage:(NSString *)message {
    return [self withMessage:message statusCode:HTTP_STATUS_CODE_INVALID_REQUEST];
}
@end

//
//  CBException.m
//  xcuitest-server
//
//  Created by Chris Fuentes on 2/10/16.
//  Copyright © 2016 calabash. All rights reserved.
//

#import "CBException.h"

@implementation CBException
+ (instancetype)withMessage:(NSString *)message {
    return [self withMessage:message statusCode:HTTP_STATUS_CODE_SERVER_ERROR];
}

+ (instancetype)withFormat:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    id ret = [self withMessage:[[NSString alloc] initWithFormat:format arguments:args]];
    va_end(args);
    return ret;
}

+ (instancetype)withMessage:(NSString *)message statusCode:(NSInteger)code {
    CBException *e = [[self alloc] initWithName:@"Exception" reason:message userInfo:nil];
    e.HTTPErrorStatusCode = code;
    return e;
}
@end

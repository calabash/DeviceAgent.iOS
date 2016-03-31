//
//  CBException.h
//  xcuitest-server
//
//  Created by Chris Fuentes on 2/10/16.
//  Copyright © 2016 calabash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBConstants.h"

@interface CBException : NSException
@property (nonatomic) NSInteger HTTPErrorStatusCode;
+ (instancetype)withFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
+ (instancetype)withMessage:(NSString *)message;
+ (instancetype)withMessage:(NSString *)message statusCode:(NSInteger)code;
@end

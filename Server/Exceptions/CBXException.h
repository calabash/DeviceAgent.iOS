
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import <Foundation/Foundation.h>

/**
 Custom NSException subclass for dealing with DeviceAgent exceptions.
 
 Using a custom subclass of exception allows for easy differentiation between
 user-caused exceptions and actual internal exceptions.
 
 We can also associate an HTTP status code with a given exception such that
 certain types of exceptions automatically return certain statuses.
 
 The `message` of a CBXException will be returned as json under the key `"error"`
 
 See CBXRoute
 */

@interface CBXException : NSException

/**
 Status code associated with a specific exception. When an exception is thrown, 
 the status code of the exception can be read and passed back to the HTTP client.
 */
@property (nonatomic) NSInteger HTTPErrorStatusCode;

/**
 Convenience constructor with format string
 @param format Format string to present to the user after string synthesis
 @param ... Format args, as in stringWithFormat:
 */
+ (instancetype)withFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

/**
 Convenience constructor with static message string
 @param message Message to present to the user
 */
+ (instancetype)withMessage:(NSString *)message;

/**
 Convenience constructor with static message string and custom statusCode 
 (to override a class's default status code)
 @param message Message to present to the user
 @param code HTTP status code to return
 */
+ (instancetype)withMessage:(NSString *)message statusCode:(NSInteger)code;

/**
 Convenience constructor with static message string and dictionary of
 additional info to present to the user.
 @param message Message to present to the user
 @param userInfo additional information to provide to the user. This is merged with
 the message into a single json object response. The message is still under the key `"error"`
 */
+ (instancetype)withMessage:(NSString *)message userInfo:(NSDictionary *)userInfo;

/**
 Convenience constructor with static message to present to the user, additional info 
 dictionary to present, and custom HTTP status code.
 
 @param message Error message to present to the user
 @param code HTTP status code to return to the user
 @param userInfo Additional info to return to the user, to be merged with the `message` param.
 */
+ (instancetype)withMessage:(NSString *)message statusCode:(NSInteger)code userInfo:(NSDictionary *)userInfo;

/**
 Return a must-override-in-subclass exception.
 @param klass The super class
 @param selector The method which needs to be implemented by subclass
 */
+ (CBXException *)overrideMethodInSubclassExceptionWithClass:(Class) klass
                                                    selector:(SEL) selector;

@end

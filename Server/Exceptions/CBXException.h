
#import <Foundation/Foundation.h>
#import "CBXConstants.h"

@interface CBXException : NSException
@property (nonatomic) NSInteger HTTPErrorStatusCode;
+ (instancetype)withFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
+ (instancetype)withMessage:(NSString *)message;
+ (instancetype)withMessage:(NSString *)message statusCode:(NSInteger)code;
+ (instancetype)withMessage:(NSString *)message userInfo:(NSDictionary *)userInfo;
+ (instancetype)withMessage:(NSString *)message statusCode:(NSInteger)code userInfo:(NSDictionary *)userInfo;
@end

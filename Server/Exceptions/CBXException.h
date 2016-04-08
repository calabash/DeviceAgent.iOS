
#import <Foundation/Foundation.h>
#import "CBXConstants.h"

@interface CBXException : NSException
@property (nonatomic) NSInteger HTTPErrorStatusCode;
+ (instancetype)withFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
+ (instancetype)withMessage:(NSString *)message;
+ (instancetype)withMessage:(NSString *)message statusCode:(NSInteger)code;
@end

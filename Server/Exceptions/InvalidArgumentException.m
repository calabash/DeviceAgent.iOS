
#import "InvalidArgumentException.h"
#import "CBXConstants.h"

@implementation InvalidArgumentException
+ (instancetype)withMessage:(NSString *)message {
    return [self withMessage:message statusCode:HTTP_STATUS_CODE_EVERYTHING_OK];
}

+ (instancetype)withMessage:(NSString *)message userInfo:(NSDictionary *)userInfo {
    return [self withMessage:message statusCode:HTTP_STATUS_CODE_EVERYTHING_OK userInfo:userInfo];
}
@end

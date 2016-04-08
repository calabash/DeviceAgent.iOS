
#import "ElementNotFoundException.h"

@implementation ElementNotFoundException
+ (instancetype)withMessage:(NSString *)message {
    return [self withMessage:message statusCode:HTTP_STATUS_CODE_EVERYTHING_OK];
}
@end

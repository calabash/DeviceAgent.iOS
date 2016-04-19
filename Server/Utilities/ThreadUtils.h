
#import <Foundation/Foundation.h>
#import "CBXTypedefs.h"

@interface ThreadUtils : NSObject
NS_ASSUME_NONNULL_BEGIN
+ (void)runSync:(AsyncBlock)block completion:(CompletionBlock)completion;
NS_ASSUME_NONNULL_END
@end

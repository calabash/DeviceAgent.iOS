
#import <Foundation/Foundation.h>
#import "CBXTypedefs.h"

/**
Utility methods for abstracting less obvious thread-related functionality.
 */
@interface ThreadUtils : NSObject
NS_ASSUME_NONNULL_BEGIN
/**
 Run an async block to completion and then synchronously execute a completion block. 
 The completion block will be executed on the same thread as the calling stack frame. 
 
 @param block AsyncBlock to wait on
 @param completion Block which executes after waiting for the async block to complete.
 @warning If you don't ever flag the AsyncBlock as complete via it's `BOOL *setToTrueWhenDone`, 
 the completion block will never execute.
 */
+ (void)runSync:(AsyncBlock)block completion:(CompletionBlock)completion;
NS_ASSUME_NONNULL_END
@end

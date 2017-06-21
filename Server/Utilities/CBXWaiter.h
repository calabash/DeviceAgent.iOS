
#import <Foundation/Foundation.h>

/**
 Wait until true block
 */
typedef BOOL (^CBXWaitUntilTrueBlock)(void);

/**
 Convenient methods for waiting.
 */
@interface CBXWaiter : NSObject

/**
 Wait for a condition to be truthy.

 @param timeout how long to wait
 @param block wait until this block returns YES
 @return YES if block evaluated to YES before timeout
 */
+ (BOOL)waitWithTimeout:(NSTimeInterval)timeout
              untilTrue:(CBXWaitUntilTrueBlock)block;

@end

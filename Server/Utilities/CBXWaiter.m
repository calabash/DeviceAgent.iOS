
#import "CBXWaiter.h"
#import "CBXMachClock.h"

@implementation CBXWaiter

+ (BOOL)waitWithTimeout:(NSTimeInterval)timeout
              untilTrue:(CBXWaitUntilTrueBlock)block {
  NSTimeInterval startTime = [[CBXMachClock sharedClock] absoluteTime];
  NSTimeInterval endTime = startTime + timeout;

  BOOL blockIsTruthy = block();
  while(!blockIsTruthy && [[CBXMachClock sharedClock] absoluteTime] < endTime) {
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.1, false);
    blockIsTruthy = block();
  }

  return blockIsTruthy;
}

@end

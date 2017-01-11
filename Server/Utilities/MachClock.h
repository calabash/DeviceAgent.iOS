#include <Foundation/Foundation.h>

@interface MachClock : NSObject

/**
 The shared clock using mach_absolute_time();

 This is a singleton class.  Calling init will throw an exception.
 @return the MachClock
 */
+ (instancetype)sharedClock;

/**
 What is the time right now?

 @return the mach absolute time as an NSTimeInterval
*/
- (NSTimeInterval)absoluteTime;

@end

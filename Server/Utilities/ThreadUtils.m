
#import "ThreadUtils.h"
#import "CBXConstants.h"

@implementation ThreadUtils
+ (void)runSync:(AsyncBlock)block {
    BOOL done = NO;
    
    block(&done);
    
    while(!done){
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, CBX_RUNLOOP_INTERVAL, false);
    }
}
@end


#import "ThreadUtils.h"
#import "CBXConstants.h"

@implementation ThreadUtils
+ (void)runSync:(AsyncBlock)block {
    BOOL done = NO;
    
    block(&done);
    
    while(!done){
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:CBX_RUNLOOP_INTERVAL]];
    }
}
@end

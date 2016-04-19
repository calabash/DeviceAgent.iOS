
#import "ThreadUtils.h"
#import "CBXConstants.h"

@implementation ThreadUtils
+ (void)runSync:(AsyncBlock)block completion:(CompletionBlock)completion {
    BOOL done = NO;
    __block NSError *err;
    block(&done, &err);
    
    while(!done){
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:CBX_RUNLOOP_INTERVAL]];
    }
    
    completion(err);
}
@end

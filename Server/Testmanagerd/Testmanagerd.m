
#import "Testmanagerd.h"
#import "NSXPCConnection.h"

@interface Testmanagerd()
@end

@implementation Testmanagerd

+ (id<XCTestManager_ManagerInterface>)get { return [XCTestDriver sharedTestDriver].managerProxy; }

@end

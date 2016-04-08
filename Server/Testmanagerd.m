
#import "Testmanagerd.h"
#import "NSXPCConnection.h"

@interface Testmanagerd()
@property (nonatomic, strong) id<XCTestManager_ManagerInterface> proxy;
@property (nonatomic, strong) NSXPCConnection *managerConnection;
@end

@implementation Testmanagerd
static Testmanagerd *testmanagerd;

- (id)init {
    if (self = [super init]) {
        self.managerConnection = [[NSXPCConnection alloc] initWithMachServiceName:@"com.apple.testmanagerd" options:0x0];
        NSXPCInterface *interface = [NSXPCInterface interfaceWithProtocol:@protocol(XCTestManager_ManagerInterface)];
        
        self.managerConnection.remoteObjectInterface = interface;
        
        [self.managerConnection.remoteObjectInterface setClasses:[NSSet setWithObjects:
                                                                  [NSData class],
                                                                  [NSString class],
                                                                  [NSArray class],
                                                                  [NSDictionary class],
                                                                  [NSDate class],
                                                                  [NSNull class],
                                                                  [NSNumber class],[XCAccessibilityElement class], nil]
                                                     forSelector:@selector(_XCT_fetchAttributesForElement:attributes:reply:) argumentIndex:0x0 ofReply:0x1];
        
        
        [self.managerConnection setExportedInterface:[NSXPCInterface interfaceWithProtocol:@protocol(XCTestManager_TestsInterface)]];
        
        [self.managerConnection setExportedObject:self];
        
        [self.managerConnection setInterruptionHandler:^{
            NSLog(@"Interruption handler");
        }];
        
        [self.managerConnection setInvalidationHandler:^{
            NSLog(@"Invalidation handler");
        }];
        
        [self.managerConnection _setQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
        
        [self.managerConnection resume];
        
        self.proxy = [self.managerConnection remoteObjectProxyWithErrorHandler:^(NSError *error) {
            NSLog(@"Error getting remote proxy: %@", error);
        }];
    }
    return self;
}

+ (void)load {
    static dispatch_once_t oncet;
    dispatch_once(&oncet, ^{
        testmanagerd = [self new];
    });
}

+ (id<XCTestManager_ManagerInterface>)get { return testmanagerd.proxy; }

@end

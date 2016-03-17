//
//  Testmanagerd.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/16/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "Testmanagerd.h"
#import "NSXPCConnection.h"

@interface Testmanagerd()
@property (nonatomic, strong) id<XCTestManager_ManagerInterface> proxy;
@end

@implementation Testmanagerd
static Testmanagerd *testmanagerd;

- (id)init {
    if (self = [super init]) {
        NSXPCConnection *connection = [[NSXPCConnection alloc] initWithServiceName:@"com.apple.testmanagerd"];
        self.proxy = [connection remoteObjectProxyWithErrorHandler:^(NSError *error) {
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

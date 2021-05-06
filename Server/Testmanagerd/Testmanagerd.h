
#import <Foundation/Foundation.h>
#import "XCTest/XCTestManager_DaemonConnectionInterface-Protocol.h"

/**
 Wrapper object for the `testmanagerd` proxy.
 
 `testmanagerd` is an iOS dæmon which we have tamed through sheer willpower and caffeine.
 
 It runs on the device and has priviledges for interacting with the entire device,
 and thus is the core component of XCUITest's underlying gesture synthesis. 
 
 It exposes an API via the `XCTestManager_ManagerInterface` which is used to 
 interact with it and by extension the device. Once and NSXPCConnection is
 established with the dæmon, automation commands can be freely sent.
 */
@interface Testmanagerd : NSObject

/**
 Return a singleton instance of the Testmanagerd proxy object, on which 
 raw testmanagerd methods may be invoked. Note that these are not all entirely
 documented, as it is a private API and we have yet to fully understand all 
 of the methods. 
 */
+ (id<XCTestManager_ManagerInterface>)get;

@end

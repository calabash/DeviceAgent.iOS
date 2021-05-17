//
//#import <Foundation/Foundation.h>
//#import "XCTest/XCTestManager_DaemonConnectionInterface-Protocol.h"
//
///**
// Wrapper object for the `testmanagerd` proxy.
//
// `testmanagerd` is an iOS dæmon which we have tamed through sheer willpower and caffeine.
//
// It runs on the device and has priviledges for interacting with the entire device,
// and thus is the core component of XCUITest's underlying gesture synthesis.
//
// Early it exposed an API via the `XCTestManager_ManagerInterface` which is used to
// interact with it and by extension the device. Once and NSXPCConnection is
// established with the dæmon, automation commands can be freely sent.
// */
// After Xcode 12.5 XCTestManager_ManagerInterface is splited into several interfaces:
//XCTMessagingRole_EventSynthesis
//XCTMessagingRole_SiriAutomation
//XCTMessagingRole_BundleRequesting
//XCTMessagingRole_MemoryTesting
//XCTMessagingRole_ForcePressureSupportQuerying
//XCTMessagingRole_CapabilityExchange
//
//Right now only two of them are used: XCTMessagingRole_EventSynthesis, XCTMessagingRole_CapabilityExchange
//That's how it looked before:
//@interface Testmanagerd : NSObject
//
///**
// Return a singleton instance of the Testmanagerd proxy object, on which
// raw testmanagerd methods may be invoked. Note that these are not all entirely
// documented, as it is a private API and we have yet to fully understand all
// of the methods.
// */
//+ (id<XCTestManager_ManagerInterface>)get;
//
//@end

#import <Foundation/Foundation.h>
#import "XCTMessagingRole_EventSynthesis-Protocol.h"

@interface Testmanagerd_EventSynthesis : NSObject
//
///**
// Return a singleton instance of the Testmanagerd proxy object, on which
// raw testmanagerd methods may be invoked. Note that these are not all entirely
// documented, as it is a private API and we have yet to fully understand all
// of the methods.
// */
+ (id<XCTMessagingRole_EventSynthesis>)get;

@end

#import "XCTMessagingRole_CapabilityExchange-Protocol.h"

@interface Testmanagerd_CapabilityExchange : NSObject
//
///**
// Return a singleton instance of the Testmanagerd proxy object, on which
// raw testmanagerd methods may be invoked. Note that these are not all entirely
// documented, as it is a private API and we have yet to fully understand all
// of the methods.
// */
+ (id<XCTMessagingRole_CapabilityExchange>)get;

@end



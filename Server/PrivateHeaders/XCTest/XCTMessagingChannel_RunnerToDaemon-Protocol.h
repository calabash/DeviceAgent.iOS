// class-dump results processed by bin/class-dump/dump.rb
//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled May  6 2021 20:43:33).
//
//  Copyright (C) 1997-2019 Steve Nygard.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <XCTest/XCUIElementTypes.h>
#import "CDStructures.h"
@protocol OS_dispatch_queue;
@protocol OS_xpc_object;

#import "XCTMessagingRole_BundleRequesting-Protocol.h"
#import "XCTMessagingRole_CapabilityExchange-Protocol.h"
#import "XCTMessagingRole_EventSynthesis-Protocol.h"
#import "XCTMessagingRole_ForcePressureSupportQuerying-Protocol.h"
#import "XCTMessagingRole_MemoryTesting-Protocol.h"
#import "XCTMessagingRole_ProtectedResourceAuthorization-Protocol.h"
#import "XCTMessagingRole_SiriAutomation-Protocol.h"
#import "_XCTMessaging_VoidProtocol-Protocol.h"

@protocol XCTMessagingChannel_RunnerToDaemon <XCTMessagingRole_ProtectedResourceAuthorization, XCTMessagingRole_CapabilityExchange, XCTMessagingRole_EventSynthesis, XCTMessagingRole_SiriAutomation, XCTMessagingRole_MemoryTesting, XCTMessagingRole_BundleRequesting, XCTMessagingRole_ForcePressureSupportQuerying, _XCTMessaging_VoidProtocol>

@optional
- (void)__dummy_method_to_work_around_68987191;
@end


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

@class NSNumber, XCTCapabilities;

@protocol XCTMessagingRole_ControlSessionInitiation
- (id)_IDE_authorizeTestSessionWithProcessID:(NSNumber *)arg1;
- (id)_IDE_initiateControlSessionForTestProcessID:(NSNumber *)arg1;
- (id)_IDE_initiateControlSessionForTestProcessID:(NSNumber *)arg1 protocolVersion:(NSNumber *)arg2;
- (id)_IDE_initiateControlSessionWithCapabilities:(XCTCapabilities *)arg1;
- (id)_IDE_initiateControlSessionWithProtocolVersion:(NSNumber *)arg1;
@end


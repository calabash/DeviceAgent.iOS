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

#import "XCTestObservation-Protocol.h"

@class XCActivityRecord, XCTContext;

@protocol _XCTestObservationPrivate <XCTestObservation>

@optional
- (void)_context:(XCTContext *)arg1 didFinishActivity:(XCActivityRecord *)arg2;
- (void)_context:(XCTContext *)arg1 willStartActivity:(XCActivityRecord *)arg2;
@end


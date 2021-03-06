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

#import "XCTElementSnapshotAttributeDataSource-Protocol.h"

@class XCTCapabilities, XCTElementQuery, XCTElementQueryResults;

@protocol XCTRunnerAutomationSession <XCTElementSnapshotAttributeDataSource>
- (XCTElementQueryResults *)matchesForQuery:(XCTElementQuery *)arg1 error:(id *)arg2;
- (void)notifyWhenAnimationsAreIdle:(void (^)(NSError *))arg1;
- (void)notifyWhenMainRunLoopIsIdle:(void (^)(NSError *))arg1;
@end


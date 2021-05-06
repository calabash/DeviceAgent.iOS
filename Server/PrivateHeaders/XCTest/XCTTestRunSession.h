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

#import <objc/NSObject.h>

#import "XCTTestWorker-Protocol.h"

@class NSString, XCTBlockingQueue, XCTestConfiguration;
@protocol XCTTestRunSessionDelegate;


@protocol XCTTestRunSessionDelegate;

@interface XCTTestRunSession : NSObject <XCTTestWorker>
{
    id <XCTTestRunSessionDelegate> _delegate;
    XCTestConfiguration *_testConfiguration;
    XCTBlockingQueue *_workQueue;
}

@property __weak id <XCTTestRunSessionDelegate> delegate;
@property(retain) XCTestConfiguration *testConfiguration;
@property(retain) XCTBlockingQueue *workQueue;

- (BOOL)_preTestingInitialization;
- (void)executeTestIdentifiers:(id)arg1 skippingTestIdentifiers:(id)arg2 completionHandler:(CDUnknownBlockType)arg3 completionQueue:(id)arg4;
- (void)fetchDiscoveredTestClasses:(CDUnknownBlockType)arg1;
- (id)initWithTestConfiguration:(id)arg1;
- (void)resumeAppSleep:(id)arg1;
- (BOOL)runTestsAndReturnError:(id *)arg1;
- (void)shutdown;
- (id)suspendAppSleep;


@end


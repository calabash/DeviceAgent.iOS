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

@class NSError, NSMutableSet, XCTPromise, XCTWaiter;

@interface XCTFuture : NSObject
{
    BOOL _canceled;
    BOOL _hasWaited;
    BOOL _hasFinished;
    id _value;
    NSError *_error;
    double _executionTime;
    double _startTime;
    double _deadline;
    XCTPromise *_promise;
    XCTWaiter *_waiter;
    NSMutableSet *_cancelationExpectations;
}

@property(readonly) NSMutableSet *cancelationExpectations;
@property(readonly) double deadline;
@property(readonly) NSError *error;
@property(readonly) double executionTime;
@property BOOL hasFinished;
@property BOOL hasWaited;
@property(readonly, getter=isCanceled) BOOL canceled;
@property(readonly) XCTPromise *promise;
@property(readonly) double startTime;
@property(readonly) id value;
@property(readonly) XCTWaiter *waiter;

+ (id)futureWithDescription:(id)arg1 block:(CDUnknownBlockType)arg2;
+ (id)futureWithTimeout:(double)arg1 description:(id)arg2 block:(CDUnknownBlockType)arg3;
- (void)_waitForFulfillment;
- (void)addCancelationExpectation:(id)arg1;
- (id)initWithTimeout:(double)arg1 promise:(id)arg2;

@end


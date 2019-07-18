// class-dump results processed by bin/class-dump/dump.rb
//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Apr 12 2019 07:16:25).
//
//  Copyright (C) 1997-2019 Steve Nygard.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <XCTest/XCUIElementTypes.h>
#import "CDStructures.h"
@protocol OS_dispatch_queue;
@protocol OS_xpc_object;

@class NSPredicate, NSRunLoop, NSString, NSTimer, XCTNSPredicateExpectation;

@interface _XCTNSPredicateExpectationImplementation : NSObject
{
    XCTNSPredicateExpectation *_expectation;
    id <XCTNSPredicateExpectationObject> _object;
    NSPredicate *_predicate;
    CDUnknownBlockType _handler;
    NSRunLoop *_timerRunLoop;
    NSTimer *_timer;
    double _pollingInterval;
    NSString *_debugDescription;
    NSObject<OS_dispatch_queue> *_queue;
    BOOL _hasCleanedUp;
    BOOL _isEvaluating;
}

@property(copy) NSString *debugDescription;
@property(copy) CDUnknownBlockType handler;
@property(readonly) id <XCTNSPredicateExpectationObject> object;
@property double pollingInterval;
@property(readonly, copy) NSPredicate *predicate;

- (void)_considerFulfilling;
- (void)_scheduleTimer;
- (BOOL)_shouldFulfillForExpectation:(id)arg1 object:(id)arg2 handler:(CDUnknownBlockType)arg3;
- (void)cleanup;
- (id)initWithPredicate:(id)arg1 object:(id)arg2 expectation:(id)arg3;
- (void)startPolling;

@end


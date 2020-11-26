// class-dump results processed by bin/class-dump/dump.rb
//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Nov 26 2020 14:08:26).
//
//  Copyright (C) 1997-2019 Steve Nygard.
//


#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <XCTest/XCUIElementTypes.h>
#import "CDStructures.h"
@protocol OS_dispatch_queue;
@protocol OS_xpc_object;

@class NSArray, XCTWaiter, XCTestExpectation;

@protocol XCTWaiterDelegate <NSObject>
- (void)nestedWaiter:(XCTWaiter *)arg1 wasInterruptedByTimedOutWaiter:(XCTWaiter *)arg2;
- (void)waiter:(XCTWaiter *)arg1 didFulfillInvertedExpectation:(XCTestExpectation *)arg2;
- (void)waiter:(XCTWaiter *)arg1 didTimeoutWithUnfulfilledExpectations:(NSArray *)arg2;
- (void)waiter:(XCTWaiter *)arg1 fulfillmentDidViolateOrderingConstraintsForExpectation:(XCTestExpectation *)arg2 requiredExpectation:(XCTestExpectation *)arg3;
@end


// class-dump results processed by bin/class-dump/dump.rb
//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2015 by Steve Nygard.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <XCTest/XCUIElementTypes.h>
#import "CDStructures.h"
@protocol OS_dispatch_queue;
@protocol OS_xpc_object;

#import <objc/NSObject.h>

@class NSArray, NSString, _XCTestExpectationImplementation;
@protocol XCTestExpectationDelegate;


@protocol XCTestExpectationDelegate;

@interface XCTestExpectation : NSObject
{
    id _internalImplementation;
}

@property(nonatomic) BOOL assertForOverFulfill;
@property(readonly, copy) NSArray *creationCallStackReturnAddresses;
@property(readonly) NSUInteger creationToken;
@property id <XCTestExpectationDelegate> delegate;
@property(copy) NSString *expectationDescription;
@property(nonatomic) NSUInteger expectedFulfillmentCount;
@property(readonly, copy) NSArray *fulfillCallStackReturnAddresses;
@property(readonly) BOOL fulfilled;
@property(nonatomic) NSUInteger fulfillmentCount;
@property(readonly) NSUInteger fulfillmentToken;
@property BOOL hasBeenWaitedOn;
@property BOOL hasInverseBehavior;
@property(readonly) _XCTestExpectationImplementation *internalImplementation;
@property(getter=isInverted) BOOL inverted;
@property(readonly) BOOL on_queue_fulfilled;
@property(readonly) NSUInteger on_queue_fulfillmentToken;
@property(readonly) BOOL on_queue_isInverted;

+ (id)compoundAndExpectationWithSubexpectations:(id)arg1;
+ (id)compoundOrExpectationWithSubexpectations:(id)arg1;
+ (id)expectationWithDescription:(id)arg1;
- (BOOL)_queue_fulfillWithCallStackReturnAddresses:(id)arg1;
- (void)cleanup;
- (void)fulfill;
- (id)initWithDescription:(id)arg1;
- (void)on_queue_setHasBeenWaitedOn:(BOOL)arg1;

@end


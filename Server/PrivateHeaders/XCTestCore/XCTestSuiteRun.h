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

#import "XCTestRun.h"

@class NSArray, NSMutableArray;

@interface XCTestSuiteRun : XCTestRun
{
    NSMutableArray *_mutableTestRuns;
}

@property(readonly) NSMutableArray *mutableTestRuns;
@property(readonly, copy) NSArray *testRuns;

- (void)_handleIssue:(id)arg1;
- (void)addTestRun:(id)arg1;
- (NSUInteger)executionCount;
- (NSUInteger)expectedFailureCount;
- (NSUInteger)failureCount;
- (id)initWithTest:(id)arg1;
- (void)recordExpectedFailure:(id)arg1;
- (NSUInteger)skipCount;
- (void)start;
- (void)stop;
- (double)testDuration;
- (NSUInteger)unexpectedExceptionCount;

@end

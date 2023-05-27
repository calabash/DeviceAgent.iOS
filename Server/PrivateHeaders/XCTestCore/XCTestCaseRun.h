// class-dump results processed by bin/class-dump/dump.rb
//
//     Generated by classdump-c 4.2.0 (64 bit) (iOS port by DreamDevLost, Updated by Kevin Bradley.)(Debug version compiled May 27 2023 00:50:17).
//
//  Copyright (C) 1997-2019 Steve Nygard. Updated in 2022 by Kevin Bradley.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <XCTest/XCUIElementTypes.h>
#import "CDStructures.h"
@protocol OS_dispatch_queue;
@protocol OS_xpc_object;

@interface XCTestCaseRun
{
}

- (void)_handleIssue:(id)arg1;
- (void)_recordValues:(id)arg1 forPerformanceMetricID:(id)arg2 name:(id)arg3 unitsOfMeasurement:(id)arg4 baselineName:(id)arg5 baselineAverage:(id)arg6 maxPercentRegression:(id)arg7 maxPercentRelativeStandardDeviation:(id)arg8 maxRegression:(id)arg9 maxStandardDeviation:(id)arg10 file:(id)arg11 line:(NSUInteger)arg12 polarity:(NSInteger)arg13;
- (void)recordExpectedFailure:(id)arg1;
- (void)recordFailureInTest:(id)arg1 withDescription:(id)arg2 inFile:(id)arg3 atLine:(NSUInteger)arg4 expected:(BOOL)arg5;
- (void)recordSkipWithDescription:(id)arg1 sourceCodeContext:(id)arg2;
- (void)start;
- (void)stop;

@end


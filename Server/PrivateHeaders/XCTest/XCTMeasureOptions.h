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

@class NSArray, NSDictionary, NSString;

@interface XCTMeasureOptions : NSObject
{
    BOOL _enableParallelizedSampling;
    BOOL _scheduleKickOffOnNewThread;
    BOOL _allowContinuousSampling;
    BOOL _discardFirstIteration;
    BOOL _traceCollectionEnabled;
    BOOL _perfdataAttachmentEnabled;
    NSUInteger _invocationOptions;
    NSUInteger _iterationCount;
    NSDictionary *_performanceTestConfiguration;
    NSArray *_performanceTraceConfigurations;
    NSString *_perfdataTestName;
    double _quiesceCpuIdlePercent;
    double _quiesceCpuIdleTimeLimit;
}

@property(nonatomic) BOOL allowConcurrentIterations;
@property(nonatomic) BOOL allowContinuousSampling;
@property(nonatomic) BOOL discardFirstIteration;
@property(readonly, nonatomic) NSUInteger instrumentAutomatic;
@property(readonly, nonatomic) NSDictionary *instrumentOptions;
@property(nonatomic) NSUInteger invocationOptions;
@property(nonatomic) NSUInteger iterationCount;
@property(nonatomic) BOOL perfdataAttachmentEnabled;
@property(retain, nonatomic) NSString *perfdataTestName;
@property(retain, nonatomic) NSDictionary *performanceTestConfiguration;
@property(copy, nonatomic) NSArray *performanceTraceConfigurations;
@property(nonatomic) double quiesceCpuIdlePercent;
@property(nonatomic) double quiesceCpuIdleTimeLimit;
@property(nonatomic) BOOL traceCollectionEnabled;

+ (id)defaultOptions;
- (void)applyPerformanceTestConfiguration;
- (id)initWithInstrumentOptionsDictionary:(id)arg1;

@end


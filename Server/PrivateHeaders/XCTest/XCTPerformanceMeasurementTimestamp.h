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

@class NSDate;

@interface XCTPerformanceMeasurementTimestamp : NSObject
{
    BOOL _hasContinuousTime;
    NSUInteger _continuousTime;
    NSUInteger _absoluteTime;
    NSDate *_date;
}

@property(readonly) NSUInteger absoluteTime;
@property(readonly) NSUInteger absoluteTimeNanoSeconds;
@property(readonly) NSUInteger continuousTime;
@property(readonly, copy) NSDate *date;
@property(readonly) BOOL hasContinuousTime;

- (id)initWithAbsoluteTime:(NSUInteger)arg1 date:(id)arg2;
- (id)initWithContinuousTime:(NSUInteger)arg1 absoluteTime:(NSUInteger)arg2 date:(id)arg3;

@end


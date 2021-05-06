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

#import "XCTMetric-Protocol.h"
#import "XCTMetric_Private-Protocol.h"

@class MXMDiskMetric, NSString;

@interface XCTStorageMetric : NSObject <XCTMetric_Private, XCTMetric>
{
    NSString *_instrumentationName;
    MXMDiskMetric *__underlyingMetric;
}

@property(retain, nonatomic) MXMDiskMetric *_underlyingMetric;
@property(readonly, nonatomic) NSString *instrumentationName;

- (void)didStartMeasuringAtTimestamp:(id)arg1;
- (void)didStopMeasuringAtTimestamp:(id)arg1;
- (id)initWithApplication:(id)arg1;
- (id)initWithProcessIdentifier:(NSInteger)arg1;
- (id)initWithProcessName:(id)arg1;
- (id)initWithUnderlyingMetric:(id)arg1;
- (void)prepareToMeasureWithOptions:(id)arg1;
- (id)reportMeasurementsFromStartTime:(id)arg1 toEndTime:(id)arg2 error:(id *)arg3;
- (void)willBeginMeasuringAtEstimatedTimestamp:(id)arg1;


@end


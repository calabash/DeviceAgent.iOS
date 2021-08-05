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

#import <objc/NSObject.h>

@class NSMutableOrderedSet, NSOrderedSet, XCTCapabilities;

@interface XCTRuntimeIssueContext : NSObject
{
    XCTCapabilities *_capabilities;
    Class _reportingDelegate;
    NSMutableOrderedSet *_mutableRuntimeIssues;
}

@property(readonly, copy) XCTCapabilities *capabilities;
@property(retain) NSMutableOrderedSet *mutableRuntimeIssues;
@property(readonly) __weak Class reportingDelegate;
@property(readonly, copy) NSOrderedSet *runtimeIssues;

+ (id)aggregationOfRuntimeIssues:(id)arg1;
+ (void)captureIssuesWithContext:(id)arg1 inScope:(CDUnknownBlockType)arg2;
+ (id)currentContext;
+ (void)reportRuntimeIssue:(id)arg1;
+ (void)reportRuntimeIssues:(id)arg1;
- (id)initWithCapabilities:(id)arg1 reportingDelegate:(Class)arg2;
- (void)reportRuntimeIssue:(id)arg1;

@end


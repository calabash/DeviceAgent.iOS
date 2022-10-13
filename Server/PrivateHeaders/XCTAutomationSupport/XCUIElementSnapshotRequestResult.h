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

#import "XCTCapabilitiesProviding-Protocol.h"
#import "XCTRuntimeIssueContextReportingDelegate-Protocol.h"

@class NSOrderedSet, NSString;

@interface XCUIElementSnapshotRequestResult : NSObject <NSSecureCoding, XCTCapabilitiesProviding, XCTRuntimeIssueContextReportingDelegate>
{
    XCElementSnapshot * _rootElementSnapshot;
    NSOrderedSet *_runtimeIssues;
}

@property(readonly) XCElementSnapshot * rootElementSnapshot;
@property(readonly, copy) NSOrderedSet *runtimeIssues;

+ (void)provideCapabilitiesToBuilder:(id)arg1;
+ (BOOL)shouldRuntimeIssueContext:(id)arg1 reportIssue:(id)arg2;
- (id)initWithRootElementSnapshot:(id)arg1 runtimeIssues:(id)arg2;


@end


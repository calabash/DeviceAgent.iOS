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

@class NSOrderedSet, NSSet, NSString, XCElementSnapshot;

@interface XCTElementQueryResults : NSObject <NSSecureCoding, XCTCapabilitiesProviding, XCTRuntimeIssueContextReportingDelegate>
{
    XCElementSnapshot * _rootElement;
    NSOrderedSet *_matchingElements;
    NSSet *_remoteElements;
    NSOrderedSet *_runtimeIssues;
    NSString *_noMatchesMessage;
}

@property(readonly, copy) NSOrderedSet *matchingElements;
@property(readonly, copy) NSString *noMatchesMessage;
@property(readonly, copy) NSSet *remoteElements;
@property(readonly) XCElementSnapshot * rootElement;
@property(readonly, copy) NSOrderedSet *runtimeIssues;

+ (void)provideCapabilitiesToBuilder:(id)arg1;
+ (BOOL)shouldRuntimeIssueContext:(id)arg1 reportIssue:(id)arg2;
- (id)initWithRootElement:(id)arg1 matchingElements:(id)arg2 remoteElements:(id)arg3 runtimeIssues:(id)arg4 noMatchesMessage:(id)arg5;
- (id)resultsByReplacingRuntimeIssues:(id)arg1;


@end


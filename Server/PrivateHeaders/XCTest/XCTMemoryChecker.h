// class-dump results processed by bin/class-dump/dump.rb
//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Apr 12 2019 07:16:25).
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

@class DTXConnection, NSMutableSet;
@protocol XCTMemoryCheckerDelegate;


@protocol XCTMemoryCheckerDelegate;

@interface XCTMemoryChecker : NSObject
{
    id <XCTMemoryCheckerDelegate> _delegate;
    NSMutableSet *_markedAddresses;
    DTXConnection *_dtxConnection;
}

@property __weak id <XCTMemoryCheckerDelegate> delegate;
@property(retain, nonatomic) DTXConnection *dtxConnection;
@property(retain) NSMutableSet *markedAddresses;

- (id)_acquireMemoryGenerationForPID:(NSInteger)arg1 withError:(id *)arg2;
- (void)_assertInvalidObjectsDeallocatedAfterScope:(CDUnknownBlockType)arg1;
- (void)_assertNoLeaksInProcessWithIdentifier:(NSInteger)arg1 withOptions:(NSInteger)arg2 inScope:(CDUnknownBlockType)arg3;
- (void)_assertNoObjectAbandonedBetweenGeneration:(id)arg1 and:(id)arg2;
- (void)_assertObjectsOfTypes:(id)arg1 inProcess:(NSInteger)arg2 invalidAfterScope:(CDUnknownBlockType)arg3;
- (id)_createGraphForNewObjectsInGeneration:(id)arg1 withPreviousGeneration:(id)arg2;
- (id)_getGraphType:(NSInteger)arg1 forPID:(NSInteger)arg2 withError:(id *)arg3;
- (void)_markInvalid:(id)arg1;
- (id)acquireGenerationMemoryGraphForApplication:(id)arg1 withError:(id *)arg2;
- (id)acquireGenerationMemoryGraphForPid:(NSInteger)arg1 withError:(id *)arg2;
- (id)acquireGenerationMemoryGraphWithError:(id *)arg1;
- (id)aquireGenerationMemoryGraphForPid:(NSInteger)arg1 withError:(id *)arg2;
- (void)assertInvalidObjectsDeallocatedAfterScope:(CDUnknownBlockType)arg1;
- (void)assertNoLeaksInApplication:(id)arg1 inScope:(CDUnknownBlockType)arg2;
- (void)assertNoLeaksInApplication:(id)arg1 withOptions:(NSInteger)arg2 inScope:(CDUnknownBlockType)arg3;
- (void)assertNoLeaksInProcessWithIdentifier:(NSInteger)arg1 inScope:(CDUnknownBlockType)arg2;
- (void)assertNoLeaksInProcessWithIdentifier:(NSInteger)arg1 withOptions:(NSInteger)arg2 inScope:(CDUnknownBlockType)arg3;
- (void)assertNoLeaksInScope:(CDUnknownBlockType)arg1;
- (void)assertNoLeaksWithOptions:(NSInteger)arg1 inScope:(CDUnknownBlockType)arg2;
- (void)assertNoObjectAbandonmentBetweenGeneration:(id)arg1 and:(id)arg2;
- (void)assertObjectsOfType:(id)arg1 inApplication:(id)arg2 invalidAfterScope:(CDUnknownBlockType)arg3;
- (void)assertObjectsOfType:(id)arg1 invalidAfterScope:(CDUnknownBlockType)arg2;
- (void)assertObjectsOfTypes:(id)arg1 inApplication:(id)arg2 invalidAfterScope:(CDUnknownBlockType)arg3;
- (void)assertObjectsOfTypes:(id)arg1 invalidAfterScope:(CDUnknownBlockType)arg2;
- (id)createGraphForNewObjectsInGeneration:(id)arg1 withPreviousGeneration:(id)arg2;
- (id)initWithDelegate:(id)arg1;
- (void)markInvalid:(id)arg1;

@end


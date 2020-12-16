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



@interface XCTApplicationStateSnapshot : NSObject <NSSecureCoding>
{
    NSInteger _processID;
    NSString *_bundleID;
    NSString *_path;
    NSUInteger _runState;
    NSUInteger _activationPolicy;
    NSUInteger _eventID;
}

@property(readonly) NSUInteger activationPolicy;
@property(readonly, copy) NSString *bundleID;
@property(readonly) NSUInteger eventID;
@property(readonly, copy) NSString *path;
@property(readonly) NSInteger processID;
@property(readonly) NSUInteger runState;

- (id)initWithBundleID:(id)arg1 path:(id)arg2 runState:(NSUInteger)arg3 processID:(NSInteger)arg4 activationPolicy:(NSUInteger)arg5 eventID:(NSUInteger)arg6;

@end


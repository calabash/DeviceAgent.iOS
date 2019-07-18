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

@class NSMutableArray, NSThread;

@interface XCTWaiterManager : NSObject
{
    NSMutableArray *_waiterStack;
    NSThread *_thread;
    NSObject<OS_dispatch_queue> *_queue;
}

@property(readonly) NSObject<OS_dispatch_queue> *queue;
@property NSThread *thread;
@property(retain) NSMutableArray *waiterStack;

+ (id)threadLocalManager;
- (void)waiterDidFinishWaiting:(id)arg1;
- (void)waiterTimedOutWhileWaiting:(id)arg1;
- (void)waiterWillBeginWaiting:(id)arg1;

@end


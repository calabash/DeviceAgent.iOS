// class-dump results processed by bin/class-dump/dump.rb
//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2015 by Steve Nygard.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <XCTest/XCUIElementTypes.h>
#import "CDStructures.h"
@protocol OS_dispatch_queue;
@protocol OS_xpc_object;

#import <objc/NSObject.h>

@class NSMutableArray;
@protocol OS_dispatch_queue;

@interface XCTMainRunLoopIdleNotifier : NSObject
{
    NSObject<OS_dispatch_queue> *_queue;
    NSMutableArray *_idleHandlers;
    struct __CFRunLoopObserver *_runLoopObserver;
}

@property(readonly) NSMutableArray *idleHandlers;
@property(readonly) NSObject<OS_dispatch_queue> *queue;
@property struct __CFRunLoopObserver *runLoopObserver;

- (void)_queue_setUpRunLoopObserver;
- (void)handleIdleObserved;
- (void)notifyWhenIdle:(CDUnknownBlockType)arg1;

@end


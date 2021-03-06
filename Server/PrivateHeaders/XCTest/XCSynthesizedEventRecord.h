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


@class NSArray, NSMutableArray, NSString;

@interface XCSynthesizedEventRecord : NSObject <NSSecureCoding>
{
    NSMutableArray *_eventPaths;
    NSString *_name;
    NSInteger _interfaceOrientation;
    NSInteger _targetProcessID;
    NSUInteger _displayID;
}

@property(readonly) NSUInteger displayID;
@property(readonly) NSArray *eventPaths;
@property(readonly) NSInteger interfaceOrientation;
@property(readonly) double maximumOffset;
@property(readonly, copy) NSString *name;
@property NSInteger targetProcessID;

- (void)addPointerEventPath:(id)arg1;
- (id)initWithName:(id)arg1;
- (id)initWithName:(id)arg1 displayID:(NSUInteger)arg2;
- (id)initWithName:(id)arg1 displayID:(NSUInteger)arg2 interfaceOrientation:(NSInteger)arg3;
- (id)initWithName:(id)arg1 interfaceOrientation:(NSInteger)arg2;
- (BOOL)synthesizeWithError:(id *)arg1;
- (void)unsetInterfaceOrientation;

@end


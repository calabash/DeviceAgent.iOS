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

@class NSString, NSUUID;

@interface XCUIInterruptionHandler : NSObject
{
    CDUnknownBlockType _block;
    NSString *_handlerDescription;
    NSUUID *_identifier;
}

@property(readonly, copy) CDUnknownBlockType block;
@property(readonly, copy) NSString *handlerDescription;
@property(readonly, copy) NSUUID *identifier;

- (id)initWithBlock:(CDUnknownBlockType)arg1 description:(id)arg2;

@end


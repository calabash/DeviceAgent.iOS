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


@class NSArray, XCTSourceCodeLocation;

@interface XCTSourceCodeContext : NSObject <NSSecureCoding>
{
    NSArray *_callStack;
    XCTSourceCodeLocation *_location;
}

@property(readonly, copy) NSArray *callStack;
@property(readonly) XCTSourceCodeLocation *location;

+ (id)sourceCodeFramesFromCallStackReturnAddresses:(id)arg1;
- (id)initWithCallStack:(id)arg1 location:(id)arg2;
- (id)initWithCallStackAddresses:(id)arg1 location:(id)arg2;
- (id)initWithLocation:(id)arg1;

@end


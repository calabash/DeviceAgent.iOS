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

#import "XCTTestIdentifier.h"

@class NSArray;

__attribute__((visibility("hidden")))
@interface _XCTTestIdentifier_Array : XCTTestIdentifier
{
    NSArray *_components;
    NSUInteger _options;
}

- (id)componentAtIndex:(NSUInteger)arg1;
- (NSUInteger)componentCount;
- (id)components;
- (id)initWithComponents:(id)arg1 options:(NSUInteger)arg2;
- (NSUInteger)options;

@end


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


@interface XCUITransformParameters : NSObject <NSCopying>
{
    NSUInteger _windowID;
    NSUInteger _displayID;
}

@property(readonly) NSUInteger displayID;
@property(readonly) NSUInteger windowID;

+ (id)transformParametersWithWindowID:(NSUInteger)arg1 displayID:(NSUInteger)arg2;

@end


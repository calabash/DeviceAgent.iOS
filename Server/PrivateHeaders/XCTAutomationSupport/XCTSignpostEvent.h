// class-dump results processed by bin/class-dump/dump.rb
//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Nov 26 2020 14:08:26).
//
//  Copyright (C) 1997-2019 Steve Nygard.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <XCTestCore/XCUIElementTypes.h>
#import "CDStructures.h"
@protocol OS_dispatch_queue;
@protocol OS_xpc_object;

#import <objc/NSObject.h>


@interface XCTSignpostEvent : NSObject <NSCopying, NSSecureCoding>
{
    NSInteger _processID;
}

@property(readonly, nonatomic) NSInteger processID;

- (id)initWithSignpostEvent:(id)arg1;

@end


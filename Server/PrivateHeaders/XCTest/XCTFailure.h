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

@class NSException, NSString, XCTFailureLocation;

@interface XCTFailure : NSObject
{
    NSString *_description;
    XCTFailureLocation *_location;
    NSException *_exception;
}

@property(readonly, copy) NSString *description;
@property(readonly) NSException *exception;
@property(retain) XCTFailureLocation *location;

+ (id)failureWithDescription:(id)arg1;
+ (id)failureWithException:(id)arg1;
+ (id)failureWithException:(id)arg1 description:(id)arg2;
- (id)initWithDescription:(id)arg1 location:(id)arg2 exception:(id)arg3;

@end

